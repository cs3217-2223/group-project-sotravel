//
//  Observer.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

protocol Observer: AnyObject {
    associatedtype DataType
    func update(data: DataType)
    func clear()
}

extension Observer {
    // Make update(data:) an optional method
    func update(data: DataType) {}
    func clear() {}
}

class UserObserver: Observer {
    typealias DataType = User
}

class UsersObserver: Observer {
    typealias DataType = [User]
}

class EventObserver: Observer {
    typealias DataType = Event
}
