//
//  UserCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol MainRepository {
    var profileCtx: UserRepository { get }
    var friendCtx: FriendRepository { get }
    var tripCtx: TripRepository { get }
    var eventCtx: EventRepository { get }
    var chatCtx: ChatRepository { get }
}
