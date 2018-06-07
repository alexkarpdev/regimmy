//
//  AddDrugCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 07.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class AddDrugCell: UITableViewCell {

    static let identifier = "AddDrugCell"
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    func configure(subEvent: DrugE) {
        
        numberLabel.text = subEvent.index
        
        nameLabel.text = subEvent.name
        
        infoLabel.isEnabled = !subEvent.info.isEmpty
        infoLabel.text = subEvent.info
        
        captionLabel.text = "Порций:"
        valueLabel.text = subEvent.servs.formatToHumanReadableForm()
        unitLabel.text = "(\((subEvent.servs * subEvent.servSize).formatToHumanReadableForm()) \(subEvent.servUnit.rawValue))"
        
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
