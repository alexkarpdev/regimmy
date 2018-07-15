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
        
        for i in (subEvents as! [ExerciseE]){
            
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
    
    func convertToExerciseE() -> ExerciseE {
        //func convertToExerciseE(sets: [ExerciseSet]? = nil) -> ExerciseE {
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
        
        //1 очищаем базу от старых записей
        for set in object.sets {
            RealmDBController.shared.realm.delete(set)
        }
        
        //2 заполняем текущими значениями (оставшимися после манипуляций)
        for set in (subEvents as! [ExerciseSet]) {
            object.sets.append(set.makeRealmObject())
        }
        
        return object
    }
    
    override func addSubEvents<T>(subEvents: [T]) where T : RootEvent {
        self.subEvents.append(contentsOf: subEvents)
    }
    
    override func removeSubEvent(at index: Int) {

    }
    
    override func reloadIndexes() { // оасстановка после изменения порядкового номера сета
        subEvents.sort{($0 as! ExerciseSet ).number < ($1 as! ExerciseSet).number}
    }
    
    
}

class ExerciseSet: RootEvent {
    var number = 0
    var repeats = 0.0
    var load = 0.0
    
    var object: RExerciseSet?
    
    override init() {
        super.init()
        number = 0
        repeats = 0.0
        load = 0.0
    }
    
    init(from realmObject: RExerciseSet) {
        super.init()
        object = realmObject
        backup()
    }
    
    override func backup() {
        super.backup()
        number = object!.number
        repeats = object!.repeats
        load = object!.load
    }
    
    func makeRealmObject() -> RExerciseSet{
        let object:RExerciseSet = self.object ?? RExerciseSet()
        object.number = number
        object.repeats = repeats
        object.load = load
        return object
    }
}
