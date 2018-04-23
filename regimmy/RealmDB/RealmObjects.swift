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

class RBaseEvent: Object {
    @objc dynamic var data = Data()
    @objc dynamic var type = ""
    @objc dynamic var name = ""
    @objc dynamic var info = ""
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

class RIngredient: Object {
    @objc dynamic var name = ""
    @objc dynamic var info = ""
    
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

class RDrug: Object {
    @objc dynamic var name = ""
    @objc dynamic var info = ""
    
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

class RExercise: Object {
    @objc dynamic var name = ""
    @objc dynamic var info = ""
    
    @objc dynamic var muscle = ""
    
    @objc dynamic var type = ""
    @objc dynamic var repsType = ""
    @objc dynamic var loadType = ""
    @objc dynamic var repsUnit = ""
    @objc dynamic var loadUnit = ""
    
    func copy() -> RExerciseE {
        let exerciseE = RExerciseE()
        
        exerciseE.name = self.name
        exerciseE.info = self.info
        exerciseE.muscle = self.muscle
        exerciseE.type = self.type
        exerciseE.repsType = self.repsType
        exerciseE.loadType = self.loadType
        exerciseE.repsUnit = self.repsUnit
        exerciseE.loadUnit = self.loadUnit
        
        return exerciseE
    }
}

class RExerciseSet: Object {
    @objc dynamic var number = 0
    @objc dynamic var repeats = 0.0
    @objc dynamic var load = 0.0
}

class RMeasure: Object {
    @objc dynamic var name = ""
    @objc dynamic var value = 0.0
    @objc dynamic var unit = ""
    
    @objc dynamic var path = ""
}




