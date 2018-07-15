//
//  RealmObjects.swift
//  regimmy
//
//  Created by Natalia Sonina on 22.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - REvents

class RBaseEvent: RBaseSubEvent {
    @objc dynamic var date = Date()
    @objc dynamic var type = ""
                //var name = ""
    //@objc dynamic var repeating = ""
    //@objc dynamic var notification = ""
}

class REating: RBaseEvent {
    @objc dynamic var prot = 0.0
    @objc dynamic var fat = 0.0
    @objc dynamic var carbo = 0.0
    @objc dynamic var cal = 0.0
    @objc dynamic var mass = 0.0
    let ingredients = List<RIngredientE>()
}

class RDrugging: RBaseEvent {
    let drugs = List<RDrugE>()
}

class RTrain: RBaseEvent {
    let exercises = List<RExerciseE>()
}

class RMeasuring: RBaseEvent {
    let measures = List<RMeasure>()
}

// MARK: - RSubEvents

class RBaseSubEvent: Object {
    @objc dynamic var name = ""
    @objc dynamic var info = ""
    @objc dynamic var index = ""
    
}

class RIngredient: RBaseSubEvent {
    
    @objc dynamic var prot = 0.0
    @objc dynamic var fat = 0.0
    @objc dynamic var carbo = 0.0
    @objc dynamic var cal = 0.0
    
    func copy() -> RIngredientE {
        let ingredientE = RIngredientE()
        
        ingredientE.name = self.name
        ingredientE.info = self.info
        ingredientE.prot = self.prot
        ingredientE.fat = self.fat
        ingredientE.carbo = self.carbo
        ingredientE.cal = self.cal
        
        return ingredientE
    }
}

class RIngredientE: RIngredient {
    @objc dynamic var mass = 0.0
    
    func setMass(value: Double) {
        self.mass = value
        let koef = mass / 100
        
        prot = prot * koef
        fat = fat * koef
        carbo = carbo * koef
        cal = cal * koef
    }
}

class RDrug: RBaseSubEvent {
    
    @objc dynamic var servSize = 0.0
    @objc dynamic var servUnit = ""
    
    func copy() -> RDrugE {
        let drugE = RDrugE()
        
        drugE.name = self.name
        drugE.info = self.info
        drugE.servSize = self.servSize
        drugE.servUnit = self.servUnit
        
        return drugE
    }
}

class RDrugE: RDrug {
    @objc dynamic var servs = 0.0
}

class RExerciseE: RExercise {
    let sets = List<RExerciseSet>()
}

class RExercise: RBaseSubEvent {
    
    @objc dynamic var muscle = ""
    
    @objc dynamic var type = "" //тип
    @objc dynamic var durationType = "" //продолжительность
    @objc dynamic var loadUnit = "" // нагрузка
    
    func copy() -> RExerciseE {
        let exerciseE = RExerciseE()
        
        exerciseE.name = self.name
        exerciseE.info = self.info
        exerciseE.muscle = self.muscle
        exerciseE.type = self.type
        exerciseE.durationType = self.durationType
        exerciseE.loadUnit = self.loadUnit
        
        return exerciseE
    }
}

class RExerciseSet: Object {
    @objc dynamic var number = 0
    @objc dynamic var repeats = 0.0
    @objc dynamic var load = 0.0
}

class RMeasure: RBaseSubEvent {
    
    //here name - measuretype.rawvalue
    
    @objc dynamic var value = 0.0
    @objc dynamic var photoName = ""
}




