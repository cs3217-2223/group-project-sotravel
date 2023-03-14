//
//  UserCtx.swift
//  Sotravel
//
//  Created by Azeem Vasanwala on 14/3/23.
//

import Foundation

protocol MainCtx {
    var profileCtx: ProfileCtx { get }
    var friendCtx: FriendCtx { get }
    var tripCtx: TripCtx { get }
    var eventCtx: EventCtx { get }
    var chatCtx: ChatCtx { get }
}
