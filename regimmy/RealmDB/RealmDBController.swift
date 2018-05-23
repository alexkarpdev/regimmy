//
//  RealmDBController.swift
//  regimmy
//
//  Created by Natalia Sonina on 22.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDBController {
    static let shared = RealmDBController()
    
    private let dbVer = 0
    
    var isIngredientsExist: Bool!
    
    let realm: Realm!
    
    init() {
        
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("RegimmyDB\(dbVer).realm")
        
        self.realm = try! Realm(configuration: config)
        
        self.isIngredientsExist = realm.objects(RIngredient.self).count > 0 ? true : false // check loaded ingredients
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    func save<T: Object>(object: T) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    func index<T: RBaseSubEvent>(of object:T) -> Int? {
        let objects = realm.objects(T.self).sorted(byKeyPath: "name")
        if let object = objects.filter("name == '\(object.name)'").first, let index = objects.index(of: object) {
            return index
        }else {
            return nil
        }
    }
//    func loadPOSOs<T:BaseSubEvent>() -> [T] {
//        var objects = load() as [T]
//        
//    }
    
    func loadRealmObjectBy<T: Object>(name: String) -> T? {
        let objects = realm.objects(T.self).sorted(byKeyPath: "name")
        if let object = objects.filter("name == '\(name)'").first {
            return object
        }else {
            return nil
        }
    }
    
    func load<T: Object>() -> [T] {
        return Array(realm.objects(T.self).sorted(byKeyPath: "name"))
    }
    
    func loadResults<T: Object>() -> Results<T>  {
        return realm.objects(T.self).sorted(byKeyPath: "name")
    }
    
    func delete<T: Object>(object: T) {
        try! realm.write {
            realm.delete(object)
        }
    }
}
