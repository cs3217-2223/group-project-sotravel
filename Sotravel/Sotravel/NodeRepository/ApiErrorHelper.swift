//
//  ApiErrorHelper.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation
import NIOHTTP1

class ApiErrorHelper {

    static func handleError(status: HTTPResponseStatus, location: String = #function, line: Int = #line) throws {
        let prefix = constructErrorPrefix(location: location, line: line)
        switch status {
        case .ok: // do nothing, no error
            return
        case .unauthorized:
            throw SotravelError.AuthorizationError("\(prefix) Call was unauthorized", nil)
        case .internalServerError:
            throw SotravelError.NetworkError("\(prefix) Server threw an error", nil)
        case .notFound:
            throw SotravelError.NetworkError("\(prefix) The route or information requested does not exist", nil)
        default:
            let errorMsg = """
            "\(prefix) Call failed with HTTP status \(status.code).\
            The description is \(status.description)
            """
            throw SotravelError.NetworkError(errorMsg, nil)
        }
    }

    static func handleNilResponse(data: String?, location: String = #function, line: Int = #line) throws -> String {
        if data == nil {
            let prefix = constructErrorPrefix(location: location, line: line)
            throw SotravelError.NetworkError("\(prefix) Call unexpectedly replied with nil data", nil)
        } else {
            return data!
        }
    }

    private static func constructErrorPrefix(location: String, line: Int) -> String {
        "[Line \(line) @ \(location)]:"
    }
}
