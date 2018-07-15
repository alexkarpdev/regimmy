//
//  POSOs.swift
//  regimmy
//
//  Created by Natalia Sonina on 20.05.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//  Plain Old Swift Objects

import Foundation
import RealmSwift

// MARK: - Generic Protocol

protocol POSOProtocol: class, Equatable {
    func saveToDB()
    func removeFromDB()
    func equals(other: Self) -> Bool
    func backup() // return object params before editing if cancel button was clicked
    func removeSubEvent(at index:Int)
    func addSubEvent<T:RootEvent>(subEvent: T)
    func removeAllSubEvents()
    func addSubEvents<T:RootEvent>(subEvents: [T])
    
}

extension POSOProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.equals(other: rhs)
    }
}

// MARK: - SubEvents

class RootEvent: POSOProtocol {
    
    var name = ""
    var info = ""
    var index = "" // for ordering in list of subevents
    
    var type: EventType?
    var date = Date ()
    
    var subEvents = [RootEvent]()
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: date)
    }
    
    init() {
        name = ""
        info = ""
    }
    
    func saveToDB() {
        fatalError("override it!")
    }
    
    func removeFromDB() {
        fatalError("override it!")
    }
    
    func equals(other: RootEvent) -> Bool {
        return (other.name == self.name) &&
            (other.info == self.info)
    }
    
    func backup() {
        fatalError("override it!")
    }
    

    func removeSubEvent(at index: Int) {
        fatalError("override it!")
    }
    
    func addSubEvent<T>(subEvent: T) where T : RootEvent {
        fatalError("override it!")
    }
    
    func removeAllSubEvents() {
        fatalError("override it!")
    }
    
    func addSubEvents<T>(subEvents: [T]) where T : RootEvent {
        fatalError("override it!")
    }
    
    func moveSubEvent(fromIndex: Int, toIndex: Int) {
        fatalError("override it!")
    }
    
    func reloadEventValues() {
       // fatalError("override it!!")
    }
    
    func reloadIndexes() {
        var index = 1
        for i in subEvents {
            i.index = "\(index)"
            index += 1
        }
    }
    
}

class BaseSubEvent <T: RBaseSubEvent> : RootEvent {
    
    var object: T?
    
    func equals<P: BaseSubEvent<T>>(other: P) -> Bool {
        return super.equals(other: other)
        
    }
    
    override func saveToDB() {
        var savedObject = T()
        try! RealmDBController.shared.realm.write {
            savedObject = makeRealmObject()
        }
        RealmDBController.shared.save(object: savedObject)
    }
    
    override func removeFromDB() {
        if let o = object {
            RealmDBController.shared.delete(object: o)
        }
    }
    
    override func backup() {
        name = object!.name
        info = object!.info
        index = object!.index
    }
    
//    func getRealmObjectFromDB() -> T? {
//        return RealmDBController.shared.loadRealmObjectBy(name: self.name)
//    }
    
    func makeRealmObject() -> T {
        let object = self.object ?? T()
        object.name = name
        object.info = info
        object.index = index
        return object
    }
    
    override init() {
        super.init()
        object = nil
    }
    
    init(from realmObject: T) {
        super.init()
        object = realmObject
        backup()
    }
    
    init(name: String, info: String, index: String) {
        super.init()
        self.object = nil
        self.name = name
        self.info = info
        self.index = index
    }
    
    init(name: String, info: String) {
        super.init()
        self.object = nil
        self.name = name
        self.info = info
        self.index = ""
    }
    
}


// MARK: - Events

protocol POSOEventProtocol : POSOProtocol {
    func removeSubEvent()
}

class BaseEvent <E: RBaseEvent>: BaseSubEvent<E> {
//    var type: EventType?
//    var date = Date()
    
    init(name: String, info: String, type: EventType, date:Date) {
        super.init(name: name, info: info)
        self.type = type
        self.date = date
    }

    override init() {
        super.init()
        type = nil
        date = Date()
    }

    override init(from realmObject: E) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        self.type = EventType(rawValue: object!.type)!
        self.date = object!.date
    }
    
    override func makeRealmObject() -> E {
        let object: E = super.makeRealmObject()
        object.type = (type?.rawValue)!
        object.date = date
        return object
    }
    
    override func addSubEvent<T>(subEvent: T) where T : RootEvent {
        subEvents.append(subEvent as! IngredientE)
        reloadEventValues()
    }
    
    override func addSubEvents<T>(subEvents: [T]) where T : RootEvent {
        self.subEvents.removeAll() // очищаем всё
        for i in subEvents {
            self.subEvents.append(i)
        }
        reloadEventValues()
        reloadIndexes()
    }
    
    override func removeSubEvent(at index: Int) {
        subEvents.remove(at: index)
        reloadEventValues()
        reloadIndexes()
    }
    
    override func removeAllSubEvents() {
        subEvents.removeAll()
        reloadEventValues()
        reloadIndexes()
    }
    
    override func moveSubEvent(fromIndex: Int, toIndex: Int) {
        subEvents.insert(subEvents.remove(at: fromIndex), at: toIndex)
        reloadIndexes()
    }
    
}








































