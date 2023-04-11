//
//  Cacheable.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

protocol Cacheable: AnyObject {
    associatedtype Key: Hashable
    associatedtype Value: Identifiable where Value.ID == Key

    var _cache: [Key: Value] { get set }

    func getValue(forKey key: Key) -> Value?
    func initCache(from values: [Value])
    func updateCache(from values: [Value])
    func clearCache()
}

extension Cacheable {
    func getValue(forKey key: Key) -> Value? {
        _cache[key]
    }

    func initCache(from values: [Value]) {
        for value in values {
            _cache[value.id] = value
        }
    }

    func updateCache(from values: [Value]) {
        for value in values where _cache[value.id] == nil {
            _cache[value.id] = value
        }
    }

    func clearCache() {
        _cache = [:]
    }
}
