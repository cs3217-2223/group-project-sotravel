//
//  AppDelegate+Injection.swif.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 22/3/23.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerRepositories()
    }
}
