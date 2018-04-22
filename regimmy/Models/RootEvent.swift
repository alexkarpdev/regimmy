//
//  RootEvent.swift
//  regimmy
//
//  Created by Natalia Sonina on 05.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation

class RootEvent {
    var date:Date
    var name:String
    var note: String?
    var type: EventType
    
    var dateTime: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm"
            return formatter.string(from: date)
        }
    }
    var dateString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.doesRelativeDateFormatting = true
            return formatter.string(from: date)
        }
    }
    
    init(date: Date, name: String, type: EventType) {
        self.date = date
        self.name = name
        self.type = type
    }
}
