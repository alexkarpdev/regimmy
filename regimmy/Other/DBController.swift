//
//  DBController.swift
//  regimmy
//
//  Created by Natalia Sonina on 21.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift

class DBController {
    init() {
        let myDog = Dog()
        myDog.name = "Nex"
        myDog.age = 1
        print("name of dog: \(myDog.name)")
        
        // Get the default Realm
        let realm = try! Realm()
        
        // Query Realm for all dogs less than 2 years old
        let puppies = realm.objects(Dog.self).filter("age < 2")
        print(puppies.count) // => 0 because no dogs have been added to the Realm yet
        
        // Persist your data easily
        try! realm.write {
            realm.add(myDog)
        }
        
        let theDogs = realm.objects(Dog.self).filter("age > 0")
        print(theDogs.count)
        
        
        (0..<theDogs.count).map{(i) in
            print("name: \(theDogs[i].name)")}
        
//        // Queries are updated in realtime
//        print(puppies.count) // => 1
//        
//        // Query and update from any thread
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let realm = try! Realm()
//                let theDogs = realm.objects(Dog.self).filter("age > 0")
//                theDogs.map{print($0.name)}
//            }
//        }
    }
}

class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}
class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var picture: Data? = nil // optionals supported
    let dogs = List<Dog>()
}

// Use them like regular Swift objects

