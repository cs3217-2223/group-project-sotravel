//
//  SotravelError.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 16/3/23.
//
// Modified from https://gist.github.com/nicklockwood/c5f075dd9e714ad8524859c6bd46069f

import Foundation
enum SotravelError: Error, CustomStringConvertible {
    case NetworkError(String, Error? = nil)
    case AuthorizationError(String, Error? = nil)
    case DecodingError(String, Error? = nil)

    // These are generic cases for errors that don't need special treatment
    case message(String, Error? = nil)
    case generic(Error)

    // Convenience constructor to save writing `ApplicationError.message(...)` all the time
    init(_ message: String) {
        self = .message(message, nil)
    }

    // Convenience constructor for converting any unknown error to an ApplicationError
    // this is useful when receiving errors where we're not sure what type they are,
    // which is more common that not given Swift's lack of Error type annotations
    init(_ error: Error) {
        if let error = error as? SotravelError {
            self = error
        } else {
            self = .generic(error)
        }
    }

    // Always handy to be able to print your errors
    var description: String {
        switch self {
        // All application-specific errors should be caught here
        case let .NetworkError(message, error),
             let .AuthorizationError(message, error),
             let .DecodingError(message, error):
            return """
                Error messge: \(message)
                Underlying error: \(String(describing: error))
                """

        // Generic errors that have no previously defined type should be caught here
        case let .message(message, error):
            return """
                Error messge (generic): \(message)
                Underlying error: \(String(describing: error))
                """
        case let .generic(error):
            if let error = error as CustomStringConvertible? {
                return error.description
            }
            // Always returns something, but not always something useful
            return (error as NSError).localizedDescription
        }
    }
}
