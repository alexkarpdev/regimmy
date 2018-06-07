//
//  EditorNutrientCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 13.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditorNutrientCell: UITableViewCell {

    static let identifier = "EditorNutrientCell"
    
    @IBOutlet weak var nutrientNameLabel: UILabel!
    @IBOutlet weak var nutrientUnitLabel: UILabel!
    @IBOutlet weak var valueField: SmartField!
    
    func configure(name: String, value: Double?, unit: String, color: UIColor, tag: Int, fieldIsEnabled: Bool, updatedHandler: @escaping (String)->()) {
        
        nutrientNameLabel.textColor = color
        valueField.textColor = color
        nutrientUnitLabel.textColor = color
        
        valueField.placeholder = (0).formatToLocal()
        
        nutrientNameLabel.text = name
        nutrientUnitLabel.text = unit == "ккал." ? "  ккал." : unit
        
        valueField.text = ""
        
        if let val = value{
            if fieldIsEnabled {
                if val != 0.0 {
                    valueField.text = val.formatToLocal()
                }
            }else{
                valueField.text = val.formatToHumanReadableForm()
            }
        }
        
        valueField.tag = tag
        valueField.isEnabled = fieldIsEnabled
        valueField.updatedHandler = updatedHandler
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueField.type = .numeric
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
