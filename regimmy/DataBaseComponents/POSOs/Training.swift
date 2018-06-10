//
//  Training.swift
//  regimmy
//
//  Created by Natalia Sonina on 09.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift

class Train: BaseEvent<RTrain> {
    
    override init() {
        super.init()
        subEvents = [ExerciseE]()
    }
    
    override init(from realmObject: RTrain) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        
        subEvents = [ExerciseE]()
        for i in 0..<object!.exercises.count {
            subEvents.append(ExerciseE(from: object!.exercises[i]))
        }
        
        subEvents.sort{Int($0.index)! < Int($1.index)!} // sort?
        
    }
    
    override func makeRealmObject() -> RTrain{
        let object: RTrain = super.makeRealmObject()
        
        for ri in object.exercises {
            var finded = false
            for i in (subEvents as! [ExerciseE]) {
                
                if ri.name == i.name {
                    ri.index = i.index
                    
                    finded = true
                    subEvents.remove(at: subEvents.index(of: i)!)
                    break
                }
            }
            if !finded {
                //delete sets of exercise
                RealmDBController.shared.realm.delete(ri)
                //RealmDBController.shared.delete(object: ri)
            }
            
        }
        
        for i in 0..<subEvents.count {
            object.exercises.append((subEvents[i] as! ExerciseE).makeRealmObject())
        }
        
        subEvents = [ExerciseE]()
        for i in 0..<object.exercises.count {
            subEvents.append(ExerciseE(from: object.exercises[i]))
        }
        subEvents.sort{Int($0.index)! < Int($1.index)!} // sort ?
        
        return object
    }
    
    override func reloadEventValues(){
        
        for i in (subEvents as! [IngredientE]){
            
        }
    }
    
}

class Exercise: BaseSubEvent<RExercise> {
    
    var muscle: MuscleType?
    var exerciseType = ExerciseType.force //тип
    var durationType = DurationType.repeats //продолжительность
    var loadUnit = LoadUnitType.mass
    
    override init() {
        super.init()
        muscle = nil
        exerciseType = ExerciseType.force //тип
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
        exerciseType = ExerciseType(rawValue: object!.type)!
        durationType = DurationType(rawValue: object!.durationType)!
        loadUnit = LoadUnitType(rawValue: object!.loadUnit)!
    }
    
    override func makeRealmObject() -> RExercise{
        let object: RExercise = super.makeRealmObject()
        object.muscle = muscle!.rawValue
        object.type = exerciseType.rawValue
        object.durationType = durationType.rawValue
        object.loadUnit = loadUnit.rawValue
        
        return object
    }
    
    func convertToIngredientE(sets: [ExerciseSet]? = nil) -> ExerciseE {
        let object = ExerciseE.init()
        object.name = name
        object.info = info
        object.muscle = muscle
        object.exerciseType = exerciseType
        object.durationType = durationType
        object.loadUnit = loadUnit
        
        return object
    }
}

class ExerciseE: BaseSubEvent<RExerciseE> {
    
    var muscle: MuscleType?
    var exerciseType = ExerciseType.force //тип
    var durationType = DurationType.repeats //продолжительность
    var loadUnit = LoadUnitType.mass
    
    override init() {
        super.init()
        muscle = nil
        exerciseType = ExerciseType.force //тип
        durationType = DurationType.repeats //продолжительность
        loadUnit = LoadUnitType.mass
    }
    
    override init(from realmObject: RExerciseE) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        muscle =  MuscleType(rawValue: object!.muscle)!
        exerciseType = ExerciseType(rawValue: object!.type)!
        durationType = DurationType(rawValue: object!.durationType)!
        loadUnit = LoadUnitType(rawValue: object!.loadUnit)!
    }
    
    override func makeRealmObject() -> RExerciseE{
        let object: RExerciseE = super.makeRealmObject()
        object.muscle = muscle!.rawValue
        object.type = exerciseType.rawValue
        object.durationType = durationType.rawValue
        object.loadUnit = loadUnit.rawValue
        
        return object
    }
    
    override func addSubEvents<T>(subEvents: [T]) where T : RootEvent {
        addSets(sets: subEvents as! [ExerciseSet])
    }
    
    func addSets(sets: [ExerciseSet]) {
        
    }
    
    override func removeSubEvent(at index: Int) {

    }
    
    override func reloadIndexes() {
        
    }
    
    
}

class ExerciseSet: RootEvent {
    var number = 0
    var repeats = 0.0
    var load = 0.0
}
