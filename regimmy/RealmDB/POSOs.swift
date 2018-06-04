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
    var carb = 0.0
    var cal = 0.0
    //var massa = 0.0
    
    override init() {
        super.init()
        prot = 0.0
        fat = 0.0
        carb = 0.0
        cal = 0.0
    }
    override func equals<P>(other: P) -> Bool where P : Ingredient {
        return super.equals(other: other) &&
            (other.prot == prot) &&
            (other.fat == fat) &&
            (other.carb == carb) &&
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
        carb = object!.carbo
        cal = object!.cal
    }
    
    override func makeRealmObject() -> RIngredient{
        let object: RIngredient = super.makeRealmObject()
        object.prot = prot
        object.fat = fat
        object.carbo = carb
        object.cal = cal
        
        return object
    }
    
    func convertToIngredientE(mass: Double = 100.0) -> IngredientE {
        let object = IngredientE.init()
        object.name = name
        object.info = info
        object.prot = prot
        object.fat = fat
        object.carb = carb
        object.cal = cal
        object.mass = mass
        
        return object
    }
    
}

class IngredientE: BaseSubEvent<RIngredientE> {
    
    var prot = 0.0
    var fat = 0.0
    var carb = 0.0
    var cal = 0.0
    var mass: Double = 0.0 {
        didSet{
            let koef = mass / 100
            prot *= koef
            fat *= koef
            carb *= koef
            cal *= koef
        }
    }
    
    override init() {
        super.init()
        prot = 0.0
        fat = 0.0
        carb = 0.0
        cal = 0.0
        mass = 0.0
    }
    override func equals<P>(other: P) -> Bool where P : IngredientE {
        return super.equals(other: other) &&
            (other.prot == prot) &&
            (other.fat == fat) &&
            (other.carb == carb) &&
            (other.cal == cal) &&
            (other.mass == mass)
    }
    
    override init(from realmObject: RIngredientE) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        prot = object!.prot
        fat = object!.fat
        carb = object!.carbo
        cal = object!.cal
        mass = object!.mass
    }
    
    override func makeRealmObject() -> RIngredientE{
        let object: RIngredientE = super.makeRealmObject()
        object.prot = prot
        object.fat = fat
        object.carbo = carb
        object.cal = cal
        object.mass = mass
        
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
}

class ExerciseSet {
    var number = 0
    var repeats = 0.0
    var load = 0.0
}

class Measure: BaseSubEvent<RMeasure> {
    var value = 0.0
    var unit: MeasureType?
    var photoImage: UIImage?
    
    override init() {
        super.init()
        value = 0.0
        unit = nil
        photoImage = nil
    }
    
    init(info: String, value:Double, unit: MeasureType, photo: UIImage? = nil) {
        super.init()
        self.name = unit.rawValue
        self.info = info
        self.value = value
        self.unit = unit
        self.photoImage = photo
    }
    
    override init(from realmObject: RMeasure) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        self.info = object!.info
        self.value = object!.value
        self.unit = MeasureType(rawValue: object!.unit)!
        self.photoImage = loadPhoto(object!.photoName)
    }
    
    override func makeRealmObject() -> RMeasure {
        let object: RMeasure = super.makeRealmObject()
        object.value = value
        object.unit = unit!.rawValue
        if let photoImage = self.photoImage, let photoName = savePhoto(photoImage) {
            object.photoName = photoName
        }
        return object
    }
    
    override func removeFromDB() {
        removePhoto(object!.photoName)
        super.removeFromDB()
    }
    
    func savePhoto(_ photoImage: UIImage) -> String? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = String(Int(Date().timeIntervalSince1970)) + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = UIImageJPEGRepresentation(photoImage, 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
                return fileName
            } catch {
                print("error saving file:", error)
            }
        }
        return nil
    }
    
    func loadPhoto(_ fileName: String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            if let image  = UIImage(contentsOfFile: imageURL.path) {
                return image
            }
        }
        return nil
    }
    
    func removePhoto(_ fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                print("file removed")
            } catch {
                print("error removing file:", error)
            }
        }
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
        self.subEvents.removeAll()
        for i in subEvents {
            self.subEvents.append(i)
        }
        reloadEventValues()
    }
    
    override func removeSubEvent(at index: Int) {
        subEvents.remove(at: index)
        reloadEventValues()
    }
    
    override func removeAllSubEvents() {
        subEvents.removeAll()
        reloadEventValues()
    }
    
    func reloadEventValues() {
        fatalError("override it!!")
    }
    
}

class Eating: BaseEvent<REating> {
    var prot = 0.0
    var fat = 0.0
    var carb = 0.0
    var cal = 0.0
    var mass = 0.0
    
    override init() {
        super.init()
        prot = 0.0
        fat = 0.0
        carb = 0.0
        cal = 0.0
        mass = 0.0
        subEvents = [IngredientE]()
    }
    
    override init(from realmObject: REating) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        prot = object!.prot
        fat = object!.fat
        carb = object!.carbo
        cal = object!.cal
        mass = object!.mass
        
        subEvents = [IngredientE]()
        for i in 0..<object!.ingredients.count {
            subEvents.append(IngredientE(from: object!.ingredients[i]))
        }
        
    }
    
    override func makeRealmObject() -> REating{
        let object: REating = super.makeRealmObject()
        object.prot = prot
        object.fat = fat
        object.carbo = carb
        object.cal = cal
        object.mass = mass
        
        for ri in object.ingredients {
            var finded = false
            for i in (subEvents as! [IngredientE]) {
                
                if ri.name == i.name {
                    if ri.mass != i.mass {
                        ri.mass = i.mass
                    }
                    finded = true
                    subEvents.remove(at: subEvents.index(of: i)!)
                    break
                }
            }
            if !finded {
                RealmDBController.shared.realm.delete(ri)
                //RealmDBController.shared.delete(object: ri)
            }
            
        }
        
        for i in 0..<subEvents.count {
            object.ingredients.append((subEvents[i] as! IngredientE).makeRealmObject())
        }
        
        subEvents = [IngredientE]()
        for i in 0..<object.ingredients.count {
            subEvents.append(IngredientE(from: object.ingredients[i]))
        }
        
        return object
    }
    
    override func reloadEventValues(){
        prot = 0.0
        fat = 0.0
        carb = 0.0
        cal = 0.0
        mass = 0.0
        
        for i in (subEvents as! [IngredientE]){
            prot += i.prot
            fat += i.fat
            carb += i.carb
            cal += i.cal
            mass += i.mass
        }
    }
    
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






























