//
//  ServiceErrorHandler.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

import Foundation

class ServiceErrorHandler {
    func handle(_ error: Error) {
        guard let sotravelError = error as? SotravelError else {
            print("Unknown error occurred, \(error.localizedDescription)")
            return
        }
        switch sotravelError {
        case .NetworkError(let message, _):
            print(message)
        case .AuthorizationError(let message, _):
            print(message)
        case .DecodingError(let message, _):
            print(message)
        case .CastingError(let message, _):
            print(message)
        case .message(let message, _):
            print(message)
        case .generic(let error):
            print(error.localizedDescription)
        }
    }
}
