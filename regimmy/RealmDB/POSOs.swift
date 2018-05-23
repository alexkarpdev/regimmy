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

protocol POSOProtocol{
    
    func saveToDB()
    //func backup() // return object params before editing if cancel button was clicked
}

// MARK: - SubEvents

class BaseSubEvent <T: RBaseSubEvent> : POSOProtocol{
    
    var name = ""
    var info = ""
    var object: T?
    
    func saveToDB() {
        var savedObject = T()
        try! RealmDBController.shared.realm.write {
            savedObject = makeRealmObject()
        }
        RealmDBController.shared.save(object: savedObject)
    }
    
    func removeFromDB() {
        if let o = object {
            RealmDBController.shared.delete(object: o)
        }
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
    
    init(from realmObject: T) {
        name = realmObject.name
        info = realmObject.info
        object = realmObject
    }
    
    init(name: String, info: String) {
        self.object = nil
        self.name = name
        self.info = info
    }
    
}

class Ingredient<T:RIngredient>: BaseSubEvent<RIngredient> {
    
    var prot = 0.0
    var fat = 0.0
    var carbo = 0.0
    var cal = 0.0
    //var massa = 0.0
    
    override init(from realmObject: RIngredient) {
        super.init(from: realmObject)
        prot = realmObject.prot
        fat = realmObject.fat
        carbo = realmObject.carbo
        cal = realmObject.cal
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
    var servs = 0.0
}

class Exercise: BaseSubEvent<RExercise> {
    var muscle: MuscleType?
    var type = ExerciseType.force //тип
    var durationType = DurationUnitType.repeats //продолжительность
    var loadUnit = LoadUnitType.mass
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






























