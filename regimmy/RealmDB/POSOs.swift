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
}

extension POSOProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.equals(other: rhs)
    }
}

// MARK: - SubEvents

class RootEvent: POSOProtocol {
    func saveToDB() {
        fatalError("override it!")
    }
    
    func removeFromDB() {
        fatalError("override it!")
    }
    
    func equals(other: RootEvent) -> Bool {
        return (other === self) && (other.name == self.name) &&
            (other.info == self.info)
    }
    
    var name = ""
    var info = ""
    
    init() {
        name = ""
        info = ""
    }
    
    func backup() {
        fatalError("override it!")
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
    }
    
//    func getRealmObjectFromDB() -> T? {
//        return RealmDBController.shared.loadRealmObjectBy(name: self.name)
//    }
    
    func makeRealmObject() -> T {
        let object = self.object ?? T()
        object.name = name
        object.info = info
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
    
    init(name: String, info: String) {
        super.init()
        self.object = nil
        self.name = name
        self.info = info
    }
    
}


class Ingredient: BaseSubEvent<RIngredient> {
    
    var prot = 0.0
    var fat = 0.0
    var carbo = 0.0
    var cal = 0.0
    //var massa = 0.0
    
    override init() {
        super.init()
        prot = 0.0
        fat = 0.0
        carbo = 0.0
        cal = 0.0
    }
    override func equals<P>(other: P) -> Bool where P : Ingredient {
        return super.equals(other: other) &&
            (other.prot == prot) &&
            (other.fat == fat) &&
            (other.carbo == carbo) &&
            (other.cal == cal)
    }
    
    override init(from realmObject: RIngredient) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        prot = object!.prot
        fat = object!.fat
        carbo = object!.carbo
        cal = object!.cal
    }
    
    override func makeRealmObject() -> RIngredient{
        let object: RIngredient = super.makeRealmObject()
        object.prot = prot
        object.fat = fat
        object.carbo = carbo
        object.cal = cal
        
        return object
    }
    
}

class Drug: BaseSubEvent<RDrug> {
    
    var servSize = 0.0
    var servUnit = DrugUnitType.mass
    
    override init() {
        super.init()
        servSize = 0.0
        servUnit = DrugUnitType.mass
    }
    
    override init(from realmObject: RDrug) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        servSize = object!.servSize
        servUnit = DrugUnitType(rawValue: object!.servUnit)!
    }
    
    override func makeRealmObject() -> RDrug{
        let object: RDrug = super.makeRealmObject()
        object.servSize = servSize
        object.servUnit = servUnit.rawValue
        
        return object
    }
}

class Exercise: BaseSubEvent<RExercise> {
    
    var muscle: MuscleType?
    var type = ExerciseType.force //тип
    var durationType = DurationType.repeats //продолжительность
    var loadUnit = LoadUnitType.mass
    
    override init() {
        super.init()
        muscle = nil
        type = ExerciseType.force //тип
        durationType = DurationType.repeats //продолжительность
        loadUnit = LoadUnitType.mass
    }
    
    override init(from realmObject: RExercise) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        muscle =  MuscleType(rawValue: object!.muscle)!
        type = ExerciseType(rawValue: object!.type)!
        durationType = DurationType(rawValue: object!.durationType)!
        loadUnit = LoadUnitType(rawValue: object!.loadUnit)!
    }
    
    override func makeRealmObject() -> RExercise{
        let object: RExercise = super.makeRealmObject()
        object.muscle = muscle!.rawValue
        object.type = type.rawValue
        object.durationType = durationType.rawValue
        object.loadUnit = loadUnit.rawValue
        
        return object
    }
}

class ExerciseSet {
    var number = 0
    var repeats = 0.0
    var load = 0.0
}

class Measure: BaseSubEvent<RMeasure> {
    var value = 0.0
    var unit: MeasureType?
    var photo: UIImage?
}

// MARK: - Events

class BaseEvent<T:RBaseEvent>: BaseSubEvent<RBaseEvent> {
    var type: EventType
    var date = Date()

    init(name: String, info: String, type: EventType, date:Date) {
        self.type = type
        self.date = date
        super.init(name: name, info: info)
    }

}

class Eating: BaseEvent<REating> {
    var prot = 0.0
    var fat = 0.0
    var carbo = 0.0
    var cal = 0.0
    var mass = 0.0
    var ingrediens = [Ingredient]()
}

class Drugging: BaseEvent<RDrugging> {
    let drugs = [Drug]()
}

class Train: BaseEvent<RTrain> {
    let exercises = [Exercise]()
}

class Measuring: BaseEvent<RMeasuring> {
    let measures = [Measure]()
}






























