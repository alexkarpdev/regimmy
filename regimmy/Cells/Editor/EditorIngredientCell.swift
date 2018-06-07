//
//  EditorIngredientCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 28.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditorIngredientCell: UITableViewCell {

    static let identifier = "EditorIngredientCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var protLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    
    @IBOutlet weak var massCaptionLabel: UILabel!
    @IBOutlet weak var massValueLabel: UILabel!
    @IBOutlet weak var massUnitLabel: UILabel!
    //@IBOutlet weak var massLabel: UILabel!
    
    //@IBOutlet weak var numberLabel: UILabel!
    
    func configure(posObject: Ingredient, mass: Double? = nil){
        
        self.nameLabel.text = posObject.name
        
        infoLabel.isEnabled = !posObject.info.isEmpty
        infoLabel.text = posObject.info
        
        var koef = 1.0
        
        if let m = mass {
            massCaptionLabel.text = "Масса"
            massValueLabel.text = m.formatToHumanReadableForm()
            massUnitLabel.text = "г"
            koef = m / 100.0
        }else{
            massCaptionLabel.text = ""
            massValueLabel.text = ""
            massUnitLabel.text = ""
        }
        
        self.protLabel.text = (posObject.prot * koef).formatToHumanReadableForm()
        self.fatLabel.text = (posObject.fat * koef).formatToHumanReadableForm()
        self.carbLabel.text = (posObject.carb * koef).formatToHumanReadableForm()
        self.calLabel.text = (posObject.cal * koef).formatToHumanReadableForm()
        
        //setMass(nil)
    }
    
//    func setMass(_ value: Double?){
//        if let v = value {
//            massCaptionLabel.text = "Масса"
//            massValueLabel.text = v.formatToHumanReadableForm()
//            massUnitLabel.text = "г"
//            let coef = v / 100
//            self.protLabel.text = posObject.prot.formatToHumanReadableForm()
//            self.fatLabel.text = posObject.fat.formatToHumanReadableForm()
//            self.carbLabel.text = posObject.carb.formatToHumanReadableForm()
//            self.calLabel.text = posObject.cal.formatToHumanReadableForm()
//        }else{
//            massCaptionLabel.text = ""
//            massValueLabel.text = ""
//            massUnitLabel.text = ""
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
