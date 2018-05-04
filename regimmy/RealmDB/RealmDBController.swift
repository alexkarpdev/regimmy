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
    
    private let realm: Realm!
    
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
    
    func load<T: Object>() -> [T] {
        return Array(realm.objects(T.self))
    }
}
