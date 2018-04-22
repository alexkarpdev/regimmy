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
    @IBOutlet weak var valueField: UITextField!
    
    func configure(name: String, value: Double?, unit: String, color: UIColor) {
        
        nutrientNameLabel.textColor = color
        valueField.textColor = color
        nutrientUnitLabel.textColor = color
        
        nutrientNameLabel.text = name
        nutrientUnitLabel.text = unit
        if let val = value{
            valueField.text = "\(val)"
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
