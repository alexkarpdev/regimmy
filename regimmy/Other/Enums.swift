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
    
    var subEventType: SubEventType? {
        switch self {
        case .train:
            return .exercise
        case .eating:
            return .ingredient
        case .measure:
            return nil
        case .drugs:
            return .drug
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
    case neck = "neck" //шея
    case shoulders = "shoulders" //плечи
    case arm = "arm" //рука
    case forearm = "forearm" //предплечье
    case chest = "chest" //грудь
    case waist = "waist" //талия
    case hips = "hips" //ягодицы
    case wrist = "wrist" //запястье
    case ankle = "ankle" //лодыжка
    case thigh = "thigh" //бедро
    case calf = "calf" //икры
    case photo = "photo"
    case weight = "weight"
    case height = "height"
    case fat = "fat"
    
    var typeImageName: String {
        switch self {
        case .photo: fallthrough
        case .weight: fallthrough
        case .height: fallthrough
        case .fat: return self.rawValue
        default:
            return self.rawValue + "-ico"
        }
    }
    
    var unit: String {
        switch self {
        case .photo: return ""
        case .weight: return "кг"
        case .fat: return "%"
        default:
        return "см"
    }
    }
}
enum MuscleType: String {
    case neck = "neck"
    case quadriceps = "quadriceps"
    case tensor = "tensor"
    case adductor = "adductor"
    case calves = "calves"
    case glutes_max = "glutes-max"
    case glutes_med = "glutes-med"
    case lumbar = "lumbar"
    case lat_dorsi = "lat-dorsi"
    case abs = "abs"
    case ext_oblique = "ext-oblique"
    case serratus = "serratus"
    case forearms = "forearms"
    case biceps_fem = "biceps-fem"
    case triceps = "triceps"
    case brachialis = "brachialis"
    case biceps = "biceps"
    case teres_major = "teres-major"
    case chest = "chest"
    case post_deltoid = "post-deltoid"
    case ant_deltoid = "ant-deltoid"
    case med_deltoid = "mid-deltoid"
    case trapezius = "trapezius"
    
    var typeImageName: String {
        return self.rawValue + "-type"
    }

}

enum PropertyType: String {
    case exerciseType = "Тип"
    case durationType = "Продолжительность"
    case loadUnitType = "Нагрузка"
    case drugUnitType = "Ед. измерения"
}

// MARK: - Exercise
enum ExerciseType: String{
    case force = "силовое"
    case cardio = "кардио"
    case stretch = "растяжка"
    case warmup = "разминка"
}

enum DurationType: String{
    case repeats = "повтры"
    case time = "время"
    case laps = "круги"
    case distance = "дистанция"
    //case other
}

enum LoadUnitType: String{
    case mass = "кг."
    case time = "минуты"
    case lap = "круги"
    case selfmass = "нет"
}

// MARK: - Drugs
enum DrugUnitType: String{
    case mass = "грамм"
    case capsule = "капсулы"
    case tablet = "таблетки"
    case scoop = "черпак"
    case volume = "мл"
    case ued = "у.е."
}


enum ReloadDataType {
    case initial, delete, insert, replace, modify
}









