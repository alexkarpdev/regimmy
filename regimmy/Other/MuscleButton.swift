//
//  MuscleButton.swift
//  regimmy
//
//  Created by Natalia Sonina on 11.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class MuscleButton: UIButton {
    
    private var muscleImageName: String = ""
    
    @IBInspectable var imageName: String {
        set { self.muscleImageName = newValue }
        get { return self.muscleImageName  }
    }
    
}
