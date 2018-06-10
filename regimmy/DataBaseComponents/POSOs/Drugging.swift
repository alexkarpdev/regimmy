//
//  Drugging.swift
//  regimmy
//
//  Created by Natalia Sonina on 09.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift

class Drugging: BaseEvent<RDrugging> {
    
    override init() {
        super.init()
        subEvents = [DrugE]()
    }
    
    override init(from realmObject: RDrugging) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        
        subEvents = [DrugE]()
        for i in 0..<object!.drugs.count {
            subEvents.append(DrugE(from: object!.drugs[i]))
        }
        
        subEvents.sort{Int($0.index)! < Int($1.index)!}
        
    }
    
    override func makeRealmObject() -> RDrugging{
        let object: RDrugging = super.makeRealmObject()
        
        for ri in object.drugs {
            var finded = false
            for i in (subEvents as! [DrugE]) {
                
                if ri.name == i.name {
                    ri.servSize = i.servSize
                    ri.servUnit = i.servUnit.rawValue
                    ri.servs = i.servs
                    ri.index = i.index
                    
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
            object.drugs.append((subEvents[i] as! DrugE).makeRealmObject())
        }
        
        subEvents = [DrugE]()
        for i in 0..<object.drugs.count {
            subEvents.append(DrugE(from: object.drugs[i]))
        }
        subEvents.sort{Int($0.index)! < Int($1.index)!}
        
        return object
    }
    
    override func reloadEventValues(){
        
        for i in (subEvents as! [DrugE]){
            
        }
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
    
    func convertToDrugE(servs: Double = 0.0) -> DrugE {
        let object = DrugE.init()
        object.name = name
        object.info = info
        object.servUnit = servUnit
        object.servSize = servSize
        object.servs = servs
        
        return object
    }
}

class DrugE: BaseSubEvent<RDrugE> {
    
    var servSize = 0.0
    var servUnit = DrugUnitType.mass
    var servs = 0.0
    
    override init() {
        super.init()
        servs = 0
        servSize = 0.0
        servUnit = DrugUnitType.mass
    }
    
    override init(from realmObject: RDrugE) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        servs = object!.servs
        servSize = object!.servSize
        servUnit = DrugUnitType(rawValue: object!.servUnit)!
    }
    
    override func makeRealmObject() -> RDrugE{
        let object: RDrugE = super.makeRealmObject()
        object.servSize = servSize
        object.servUnit = servUnit.rawValue
        object.servs = servs
        return object
    }
}
