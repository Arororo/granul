//
//  Result.swift
//  granular
//
//  Created by Dmitry Babenko on 2019-05-25.
//  Copyright © 2019 Decowareb. All rights reserved.
//

import Foundation

/// A generic type of either .success(T), or .failure(U), U is usually an `Error`
public enum Result<T, U>: CustomStringConvertible, CustomDebugStringConvertible {
    /// Success with associated value `T`
    case success(T)
    /// Failure with associated value `Swift.Error`
    case failure(U)
    
    /// Handy way to find out if the result was a success or not
    public var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    //MARK: CustomStringConvertible
    
    /// String description of the result
    public var description: String {
        switch self {
        case let .success(value):
            return ".success(\(value))"
        case let .failure(value):
            return ".failure(\(value))"
        }
    }
    
    //MARK: CustomDebugStringConvertible
    
    /// String description of the result
    public var debugDescription: String {
        return description
    }
}

public extension Result {
    /// Init with two optional values. Useful to convert UIKit APIs that return a `(T?, Error?)` into a Result type.
    ///
    /// - Parameters:
    ///   - value: Optional success value
    ///   - error: Optional failure value
    init?(value: T?, error: U?) {
        switch (value, error) {
        case (let v?, _):
            self = .success(v)
        case (nil, let e?):
            self = .failure(e)
        case (nil, nil):
            return nil
        }
    }
}

public typealias ResultWithError<T> = Result<T, Error>
