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
        if status == HTTPResponseStatus.unauthorized {
            throw SotravelError.AuthorizationError("[\(location)]: Call was unauthorized", nil)
        }
        if status != HTTPResponseStatus.ok {
            throw SotravelError.NetworkError("[\(location)]: Call failed", nil)
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
