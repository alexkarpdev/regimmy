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



// MARK: - SubEvents

class BaseSubEvent <T: RBaseSubEvent> {
    
    var name = ""
    var info = ""
    
    func saveToDB() {
        RealmDBController.shared.save(object: makeRealmObject())
    }
    
    func removeFromDB() {
        RealmDBController.shared.delete(object: getRealmObjectFromDB()!)
    }
    
    func getRealmObjectFromDB() -> T? {
        return RealmDBController.shared.loadRealmObjectBy(name: self.name)
    }
    
    func makeRealmObject() -> T {
        let object = T()
        object.name = name
        object.info = info
        return object
    }
    
    init(from realmObject: T) {
        name = realmObject.name
        info = realmObject.info
    }
    
    init(name: String, info: String) {
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
        let object: RIngredient = RIngredient()
        object.name = name
        object.info = info
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






























