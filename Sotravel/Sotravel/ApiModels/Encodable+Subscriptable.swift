//
//  Encodable+Subscriptable.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 24/3/23.
//

import Foundation
struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        dictionary[key]
    }
    var dictionary: [String: Any] {
        (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
