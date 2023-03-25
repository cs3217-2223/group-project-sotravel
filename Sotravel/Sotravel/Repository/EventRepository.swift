//
//  EventCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol EventRepository {
    func get(id: Int) async throws
    func get() async throws
    func create()
    func cancelEvent(id: Int) async throws
}
