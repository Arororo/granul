//
//  APIConnector.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation

enum APIMethod: String {
    case get = "GET",
    delete = "DELETE",
    head = "HEAD",
    patch = "PATCH",
    post = "POST",
    put = "PUT",
    update = "UPDATE"
}

enum RequestError: Error, Equatable {
    case unknown
    case notFound
    case serverError(GRServerError)
    case jsonDecodingFailure
    case dataInconsistency
    
    init?(statusCode: Int, serverError: GRServerError?) {
        switch statusCode {
        case 200, 201:
            return nil
        case 404:
            self = .notFound
        default:
            if let serverError = serverError {
                self = .serverError(serverError)
            } else {
                self = RequestError.unknownServerError()
            }
        }
    }
    
    static func ==(lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown):
            return true
        case (.notFound, .notFound):
            return true
        case (let .serverError(lhsServerError), let .serverError(rhsServerError)):
            return lhsServerError.message == rhsServerError.message && lhsServerError.code == rhsServerError.code
        case (.jsonDecodingFailure, .jsonDecodingFailure):
            return true
        case (.dataInconsistency, .dataInconsistency):
            return true
        case (.unknown, _), (.notFound, _), (.serverError(_), _), (.jsonDecodingFailure, _), (.dataInconsistency, _):
            return false
        }
    }
    
    static func unknownServerError() -> RequestError {
        return RequestError.serverError(GRServerError(message: nil, code: .unknown))
    }
}

struct GRServerError: Error, Codable {
    enum ErrorCode: Int, Codable {
        case unknown = 10000
        case limitReached = 10001
    }
    
    let message: String?
    let code: ErrorCode?
}

enum DateError: String, Error {
    case invalidDate
}

protocol APIConnector {
    var baseURL: String { get }
    func performRequest<T>(method: APIMethod,
                           path: String,
                           queryParameters: [String : Any],
                           completion: @escaping (Result<T, Error>) -> Void) where T : Decodable
    init(with configuration: APIConnectorConfiguration)
}

struct APIConnectorConfiguration{
    var scheme: String
    var baseURL: String
}
