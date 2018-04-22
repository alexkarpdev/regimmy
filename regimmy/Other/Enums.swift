//
//  Enums.swift
//  regimmy
//
//  Created by Natalia Sonina on 05.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import UIKit


enum EventType: String {
    case train = "train"
    case eating = "eating"
    case measure = "measure"
    case drugs = "drugs"
    
    var image: UIImage {
        get {
            let imageName: String
            switch self {
            case .train:
                imageName = "train"
            case .eating:
                imageName = "eating"
            case .measure:
                imageName = "measure"
            case .drugs:
                imageName = "drugs"
//            default:
//                imageName = ""
            }
            
            return UIImage(named: imageName)!
        }
    }
    
    var name: String {
        get {
            let rowName: String
            switch self {
            case .train:
                rowName = "Тренировку"
            case .eating:
                rowName = "Приём пищи"
            case .measure:
                rowName = "Измерения"
            case .drugs:
                rowName = "Приём препаратов"
                //            default:
                //                imageName = ""
            }
            
            return rowName
        }
    }
}

enum SubEventType: String {
    
    case exercise = "exercise"
    case ingredient = "ingredient"
    case drug = "drug"
    
    var image: UIImage {
        get {
            let imageName: String
            switch self {
            case .exercise:
                imageName = "train"
            case .ingredient:
                imageName = "eating"
            case .drug:
                imageName = "drugs"
            }
            
            return UIImage(named: imageName)!
        }
    }
    
    var name: String {
        get {
            let rowName: String
            switch self {
            case .exercise:
                rowName = "Упаржнения"
            case .ingredient:
                rowName = "Ингредиенты"
            case .drug:
                rowName = "Препараты"
            }
            
            return rowName
        }
    }
}

enum MeasureType: String {
    case neck = "neck"
    case shoulders = "shoulders"
    case arm = "arm"
    case forearm = "forearm"
    case chest = "chest"
    case weist = "weist"
    case hips = "hips"
    case wrist = "wrist"
    case ankle = "ankle"
    case thigh = "thigh"
    case calf = "calf"
    case photo = "photo"
    case weight = "weight"
    case height = "height"
    case fat = "fat"
}
enum MuscleType: String {
    case neck = "neck"
    case shoulders = "shoulders"
    case arm = "arm"
    case forearm = "forearm"
    case chest = "chest"
    case weist = "weist"
    case hips = "hips"
    case wrist = "wrist"
    case ankle = "ankle"
    case thigh = "thigh"
    case calf = "calf"
    case photo = "photo"
    case weight = "weight"
    case height = "height"
    case fat = "fat"
}

enum ExerciseType: String{
    case force = "force"
    case cardio = "cardio"
    case stretch = "focardiorce"
}

enum DurationUnitType: String{
    case repeats = "repeats"
    case time = "cardio"
    case lap = "lap"
    case distance = "km"
    case other
}

enum LoadUnitType: String{
    case kg = "kg"
    case time = "cardio"
    case lap = "lap"
}











