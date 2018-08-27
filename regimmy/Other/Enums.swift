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
    
    var sectionColor: UIColor {
        let a: CGFloat = 0.2
        switch self {
        case .train:
            return #colorLiteral(red: 0.1647059023, green: 0.231372565, blue: 0.4627450705, alpha: 1).withAlphaComponent(a)
        case .eating:
            return #colorLiteral(red: 0.3450980783, green: 0.6431373358, blue: 0.2588234842, alpha: 1).withAlphaComponent(a)
        case .measure:
            return #colorLiteral(red: 0.9764706492, green: 0.8823530078, blue: 0.5764706731, alpha: 1).withAlphaComponent(a)
        case .drugs:
            return #colorLiteral(red: 0.2470588684, green: 0.5725491047, blue: 0.7686274648, alpha: 1).withAlphaComponent(a)
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
    
    var order: Int {
        switch self {
        case .train:
            return 1
        case .eating:
            return 0
        case .measure:
            return 2
        case .drugs:
            return 3
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
    case photo = "phototake"
    case weight = "weight"
    case height = "height"
    case fat = "bodyfat"
    
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
    var caption: String {
        switch self {
        case .neck: return "Шея"
        case .shoulders: return "Плечи"
        case .arm: return "Руки"
        case .forearm: return "Предплечье"
        case .chest: return "Грудь"
        case .waist: return "Талия"
        case .hips: return "Ягодицы"
        case .wrist: return "Запястье"
        case .ankle: return "Лодыжка"
        case .thigh: return "Бедро"
        case .calf: return "Икры"
        case .photo: return "Фото"
        case .weight: return "Вес"
        case .height: return "Рост"
        case .fat: return "Жир"
        }
    }
    
    var internalIndex: Int {
        switch self {
        case .neck: return 0
        case .shoulders: return 1
        case .arm: return 2
        case .forearm: return 3
        case .chest: return 4
        case .waist: return 5
        case .hips: return 6
        case .wrist: return 7
        case .ankle: return 8
        case .thigh: return 9
        case .calf: return 10
        case .photo: return 14
        case .weight: return 11
        case .height: return 13
        case .fat: return 12
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
    
    var unit: String {
        switch self {
        case .repeats:
            return ""
        case .time:
            return "сек"
        case .laps:
            return ""
        case .distance:
            return "м"
        }
    }
    
    var caption: String {
        switch self {
        case .repeats:
            return "Повторов"
        case .time:
            return "Прод-ть"
        case .laps:
            return "Кругов"
        case .distance:
            return "Дистанция"
        }
    }
    //case other
}

enum LoadUnitType: String{
    case mass = "кг."
    case time = "минуты"
    case laps = "круги"
    case selfmass = "нет"
    
    var unit: String {
        switch self {
        case .mass:
            return "кг."
        case .time:
            return "сек"
        case .laps:
            return ""
        case .selfmass:
            return ""
        }
    }
    
    var caption: String {
        switch self {
        case .mass:
            return "Нагрузка"
        case .time:
            return "Прод-ть"
        case .laps:
            return "Кругов"
        case .selfmass:
            return "Нагрузка"
        }
    }
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









