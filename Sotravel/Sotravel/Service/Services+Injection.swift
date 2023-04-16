//
//  Services+Injection.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 16/4/23.
//

import Foundation
import Resolver

extension Resolver {
    public static func registerServices() {
        register { UserService() }
        register { ServiceErrorHandler() }
    }
}
