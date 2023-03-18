//
//  HTTPClientRequest+NodeAuth.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 18/3/23.
//

import Foundation
import AsyncHTTPClient

extension HTTPClientRequest {
    mutating func addBearerToken(token: String?) {
        if token != nil {
            self.headers.add(name: "Authorization", value: "Bearer \(token)")
        }
    }

    mutating func setContentTypeToJson() {
        self.headers.add(name: "Content-Type", value: "application/json; charset=utf-8")
    }
}
