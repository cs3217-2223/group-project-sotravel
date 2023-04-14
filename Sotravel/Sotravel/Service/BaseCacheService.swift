//
//  BaseCacheService.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

import Foundation
import Combine

class BaseCacheService<T: Identifiable> {
    private var cache: [T.ID: T]

    init() {
        self.cache = [:]
    }

    func get(id: T.ID) -> T? {
        cache[id]
    }

    func getOptional(optionalId: T.ID?) -> T? {
        guard let id = optionalId else {
            return nil
        }
        return cache[id]
    }

    func getAll() -> [T] {
        Array(cache.values)
    }

    func getIds() -> [T.ID] {
        Array(cache.keys)
    }

    func clearCache() {
        self.cache = [:]
    }

    func initCache(from items: [T]) {
        for item in items {
            self.cache[item.id] = item
        }
    }

    func updateCache(from item: T) {
        cache[item.id] = item
    }

    func remove(item: T.ID) {
        cache[item] = nil
    }

    func updateCacheInLoop(from items: [T]) {
        for item in items where cache[item.id] == nil {
            cache[item.id] = item
        }
    }
}
