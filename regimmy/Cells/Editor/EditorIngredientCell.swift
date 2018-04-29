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
    
    @IBOutlet weak var ingredientNameLabel: UILabel!
    
    @IBOutlet weak var protLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    func configure(name: String, prot: Double, fat: Double, carb: Double, cal: Double, mass: Double = 100, number: Double = 0){
    
        
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
