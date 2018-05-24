//
//  EditorDrugCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 20.05.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditorDrugCell: UITableViewCell {

    static let identifier = "EditorDrugCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    func configure(posObject: Drug) {
        nameLabel.text = posObject.name
        
        infoLabel.isEnabled = !posObject.info.isEmpty
        infoLabel.text = posObject.info
        
        valueLabel.text = posObject.servSize.formatToHumanReadableForm()
        unitLabel.text = posObject.servUnit.rawValue
        
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
