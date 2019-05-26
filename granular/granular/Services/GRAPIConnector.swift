//
//  GRAPIConnector.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation

class GRAPIConnector: APIConnector {
    let scheme: String
    let baseURL: String
    
    var decoder:JSONDecoder!
    private let session = URLSession.shared
    
    required init(with configuration: APIConnectorConfiguration) {
        scheme = configuration.scheme
        baseURL = configuration.baseURL
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let unixtimestamp = try? container.decode(Int.self)
            if let unixtimestamp = unixtimestamp {
                return Date.init(timeIntervalSince1970: Double(unixtimestamp))
            }
            throw DateError.invalidDate
        })
    }
    
    /// Perform a request with given parameters.
    ///
    /// - Parameters:
    ///   - method: HTTP method, POST, GET, etc.
    ///   - path: The path to the endpoint, eg '/list.json'
    ///   - queryParameters: The query string parameters for the request
    ///   - completion: Completion handler will be called with a success if the response data can be de-JSONSerialized to a `T`, otherwise .failure with an error. Errors can be `RequestError` type, but that's not guaranteed.
    func performRequest<T>(method: APIMethod,
                           path: String,
                           queryParameters: [String : Any],
                           completion: @escaping (ResultWithError<T>) -> Void) where T : Decodable {
        let headerParameters = ["Content-Type": "application/json",
                                "Accept": "application/json"]
        var params = [String : Any]()
        params.merge(dictionary: queryParameters)
        guard let requestURL = self.requestURL(path: path, queryParams: params) else {
            completion(ResultWithError.failure(RequestError.dataInconsistency))
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headerParameters
        let task = session.dataTask(with: request, completionHandler: {data, urlresponse, error -> Void in
            guard let response = urlresponse as? HTTPURLResponse else {
                let errorMessage = "Something really wrong!!! We are unable to recognize the task's response"
                print(errorMessage)
                completion(ResultWithError.failure(GRServerError(message: errorMessage, code: .unknown)))
                return
            }
            var serverError: GRServerError? = nil
            if let data = data {
                serverError = try? self.decoder.decode(GRServerError.self, from: data)
            }
            
            if let error = RequestError(statusCode: response.statusCode, serverError: serverError) {
                if let data = data {
                    let responseData = String(data: data, encoding:.utf8)
                    print(responseData ?? "No data returned from backend with error.")
                } else {
                    print("\(error)")
                }
                completion(ResultWithError.failure(error))
                
                // Try to cast to desired T
            } else if var data = data {
                //Replaces data with an empty object in case we get a 200 w/o response body
                if data.isEmpty {
                    data = "{}".data(using: .utf8)!
                }
                do {
                    let expectedObject = try self.decoder.decode(T.self, from: data)
                    completion(ResultWithError<T>.success(expectedObject))
                } catch {
                    print("\(error)")
                    completion(ResultWithError.failure(RequestError.jsonDecodingFailure))
                }
            } else {
                completion(ResultWithError.failure(RequestError.unknownServerError()))
            }
            
            
        })
        task.resume()
    }
    
    func reset() {
        
    }
    
    //MARK: -Helpers
    private func requestURL(path: String, queryParams: Dictionary<String, Any>) -> URL? {
        guard let queryParamsConverted = try? processParams(queryParams) else {
            return nil
        }
        let queryItems = queryParamsConverted.map {URLQueryItem(name: $0, value: $1)}
        var urlComponents = URLComponents(string: baseURL + path)
        if urlComponents == nil {
            urlComponents = URLComponents()
            urlComponents?.host = baseURL
            urlComponents?.path = path
        }
        urlComponents?.scheme = scheme
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    private func processParams(_ queryParams: Dictionary<String, Any>) throws -> Dictionary<String, String> {
        let processedParams = try? queryParams.mapValues { obj -> String in
            if let stringValue = stringifyValue(obj) {
                return stringValue
            } else {
                throw RequestError.dataInconsistency
            }
        }
        if let processedParams = processedParams {
            return processedParams
        } else {
            throw RequestError.dataInconsistency
        }
    }
    
    private func stringifyValue(_ obj: Any) -> String? {
        if let result = obj as? String {
            return result
        }
        if let result = obj as? Array<String> {
            return result.joined(separator: ",")
        }
        if let result = obj as? Array<Float> {
            return result.map {String($0)}.joined(separator: ",")
        }
        if let result = obj as? Array<Int> {
            return result.map {String($0)}.joined(separator: ",")
        }
        if let result = obj as? Array<Double> {
            return result.map {String($0)}.joined(separator: ",")
        }
        
        if let convertableObj = obj as? LosslessStringConvertible {
            return convertableObj.description
        }
        return nil
    }
}

extension Dictionary {
    
    mutating func merge(dictionary: Dictionary) {
        dictionary.forEach { self.updateValue($1, forKey: $0) }
    }
}
