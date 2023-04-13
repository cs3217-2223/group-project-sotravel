//
//  Subject.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

protocol Subject: AnyObject {
    associatedtype ObservedData: Hashable
    associatedtype ObserverProtocol: Observer where ObserverProtocol.ObservedData == ObservedData

    var observers: [ObservedData: [ObserverProtocol]] { get set }
}

extension Subject {
    func initObservers(_ data: ObservedData, _ obs: [ObserverProtocol]) {
        observers[data] = obs
        notifyAll(for: data)
    }

    func addObserver(_ obs: ObserverProtocol, for data: ObservedData) {
        observers[data, default: []].append(obs)
    }

    func removeObserver(_ obs: ObserverProtocol, for data: ObservedData) {
        observers[data]?.removeAll(where: { $0 === obs })
    }

    func removeAllObservers(for data: ObservedData) {
        observers[data] = nil
    }

    func notifyAll(for data: ObservedData) {
        observers[data]?.forEach { observer in
            observer.updateFrom(data: data)
        }
    }

    func clearAllObservers() {
        observers.forEach { _, observers in
            observers.forEach { observer in
                observer.clear()
            }
        }
    }
}
