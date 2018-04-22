//
//  RealmObjects.swift
//  regimmy
//
//  Created by Natalia Sonina on 22.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - Table view data source

class RBaseEvent: Object {
    @objc dynamic var data = Data()
    @objc dynamic var type = ""
    @objc dynamic var name = ""
    @objc dynamic var info = ""
    
}
