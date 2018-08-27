//
//  Eating.swift
//  regimmy
//
//  Created by Natalia Sonina on 09.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift

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
        
        subEvents.sort{Int($0.index)! < Int($1.index)!}
        
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
                    ri.mass = i.mass
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
            object.ingredients.append((subEvents[i] as! IngredientE).makeRealmObject())
        }
        
        subEvents = [IngredientE]()
        for i in 0..<object.ingredients.count {
            subEvents.append(IngredientE(from: object.ingredients[i]))
        }
        subEvents.sort{Int($0.index)! < Int($1.index)!}
        
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
        
        let koef = mass / 100
        
        object.name = name
        object.info = info
        
        object.prot = prot * koef
        object.fat = fat * koef
        object.carb = carb * koef
        object.cal = cal * koef
        
        object.mass = mass
        
        return object
    }
    
}

class IngredientE: BaseSubEvent<RIngredientE> {
    
    var prot = 0.0
    var fat = 0.0
    var carb = 0.0
    var cal = 0.0
    var mass = 0.0 // вычислять в другом месте
    //    var mass: Double = 0.0 {
    //        didSet{
    //            let koef = mass / 100
    //            prot *= koef
    //            fat *= koef
    //            carb *= koef
    //            cal *= koef
    //        }
    //    }
    
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
