//
//  Subject.swift
//  Sotravel
//
//  Created by Weiqiang Zhang on 11/4/23.
//

protocol Subject: AnyObject {
    associatedtype DataType: Hashable
    associatedtype ObserverType: Observer where ObserverType.DataType == DataType

    var observers: [DataType: [ObserverType]] { get set }
}

extension Subject {
    func addObserver(_ obs: ObserverType, for data: DataType) {
        observers[data, default: []].append(obs)
    }

    func removeObserver(for data: DataType) {
        observers[data] = nil
    }

    func notifyAll(for data: DataType) {
        observers[data]?.forEach { observer in
            observer.update(data: data)
        }
    }

    func clearAll() {
        observers.forEach { _, observers in
            observers.forEach { observer in
                observer.clear()
            }
        }
    }
}
