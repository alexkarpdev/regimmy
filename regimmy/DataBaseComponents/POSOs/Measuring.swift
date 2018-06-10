//
//  Measuring.swift
//  regimmy
//
//  Created by Natalia Sonina on 09.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import RealmSwift

class Measuring: BaseEvent<RMeasuring> {
    override init() {
        super.init()
        subEvents = [DrugE]()
    }
    
    override init(from realmObject: RMeasuring) {
        super.init(from: realmObject)
        backup()
    }
    
    override func backup() {
        super.backup()
        
        subEvents = [Measure]()
        for i in 0..<object!.measures.count {
            subEvents.append(Measure(from: object!.measures[i]))
        }
        
        reorderMeasures()
        
    }
    
    override func makeRealmObject() -> RMeasuring{
        let object: RMeasuring = super.makeRealmObject()
        
        for ri in object.measures {
            var finded = false
            for i in (subEvents as! [Measure]) {
                
                if ri.name == i.name {
                    ri.value = i.value
                    if let p = i.photoImage, let pn = i.savePhoto(p){
                        i.removePhoto(ri.photoName)
                        ri.photoName = pn
                    }
                    ri.index = i.index
                    
                    finded = true
                    subEvents.remove(at: subEvents.index(of: i)!)
                    break
                }
            }
            if !finded {
                Measure().removePhoto(ri.photoName)
                RealmDBController.shared.realm.delete(ri)
                // how to remove pfhoto file
                //RealmDBController.shared.delete(object: ri)
            }
        }
        
        for i in 0..<subEvents.count {
            object.measures.append((subEvents[i] as! Measure).makeRealmObject())
        }
        
        subEvents = [Measure]()
        for i in 0..<object.measures.count {
            subEvents.append(Measure(from: object.measures[i]))
        }
        
        reorderMeasures()
        
        return object
    }
    
    func reorderMeasures(){
        subEvents.sort{($0 as! Measure).measureType!.internalIndex < ($1 as! Measure).measureType!.internalIndex}
        super.reloadIndexes()
    }
    
    override func addSubEvents<T>(subEvents: [T]) where T : RootEvent {
        super.addSubEvents(subEvents: subEvents)
        reorderMeasures()
    }
    
    
    override func reloadEventValues(){
        
        for i in (subEvents as! [Measure]){
            
        }
    }
}

class Measure: BaseSubEvent<RMeasure> {
    var value = 0.0
    var measureType: MeasureType? {
        didSet {
            if let val = self.measureType?.rawValue {
                self.name = val
            }
        }
    }
    var photoImage: UIImage?
    
    override init() {
        super.init()
        value = 0.0
        measureType = nil
        photoImage = nil
    }
    
    init(value:Double, measureType: MeasureType, photo: UIImage? = nil) {
        super.init()
        self.name = measureType.rawValue
        self.info = ""
        self.value = value
        self.measureType = measureType
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
        self.measureType = MeasureType(rawValue: object!.name)!
        self.photoImage = loadPhoto(object!.photoName)
    }
    
    override func makeRealmObject() -> RMeasure {
        let object: RMeasure = super.makeRealmObject()
        object.value = value
        if let photoImage = self.photoImage, let photoName = savePhoto(photoImage) {
            object.photoName = photoName
        }
        return object
    }
    
    override func removeFromDB() { // erorr reason: 'The Realm is already in a write transaction'
        removePhoto(object!.photoName)
        super.removeFromDB()
    }
    
    func savePhoto(_ photoImage: UIImage) -> String? { // when?
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
