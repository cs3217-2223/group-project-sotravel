//
//  Observer.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

protocol Observer: AnyObject {
    associatedtype ObservedData
    func updateFrom(data: ObservedData)
    func clear()
}

class UserObserver: Observer {
    typealias ObservedData = User
    func updateFrom(data: ObservedData) {}
    func clear() {}
}

class UsersObserver: Observer {
    typealias ObservedData = [User]
    func updateFrom(data: ObservedData) {}
    func clear() {}
}

class EventObserver: Observer {
    typealias ObservedData = Event
    func updateFrom(data: ObservedData) {}
    func clear() {}
}
