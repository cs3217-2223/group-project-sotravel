//
//  ApiErrorHelper.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 26/3/23.
//

import Foundation
import NIOHTTP1

class ApiErrorHelper {
    static func handleError(location: String, status: HTTPResponseStatus) throws {
        switch status {
        case .ok: // do nothing, no error
            return
        case HTTPResponseStatus.unauthorized:
            throw SotravelError.AuthorizationError("[\(location)]: Call was unauthorized", nil)
        case .internalServerError:
            throw SotravelError.AuthorizationError("[\(location)]: Server threw an error", nil)
        default:
            let errorMsg = """
            "[\(location)]: Call failed with HTTP status \(status.code).\
            The description is \(status.description)
            """
            throw SotravelError.NetworkError(errorMsg, nil)
        }
    }

    static func handleNilResponse(location: String, data: String?) throws -> String {
        if data == nil {
            throw SotravelError.NetworkError("[\(location)]: Call replied with nil data", nil)
        } else {
            return data!
        }
    }
}
