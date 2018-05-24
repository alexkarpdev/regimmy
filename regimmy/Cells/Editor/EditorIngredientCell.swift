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
    
    //@IBOutlet weak var massLabel: UILabel!
    
    //@IBOutlet weak var numberLabel: UILabel!
    
    func configure(posObject: Ingredient){
        
        self.nameLabel.text = posObject.name
        
        infoLabel.isEnabled = !posObject.info.isEmpty
        infoLabel.text = posObject.info
        
        self.protLabel.text = posObject.prot.formatToHumanReadableForm()
        self.fatLabel.text = posObject.fat.formatToHumanReadableForm()
        self.carbLabel.text = posObject.carbo.formatToHumanReadableForm()
        self.calLabel.text = posObject.cal.formatToHumanReadableForm()
        
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
