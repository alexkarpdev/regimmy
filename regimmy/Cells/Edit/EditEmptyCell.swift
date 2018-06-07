//
//  EditEmptyCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 05.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditEmptyCell: UITableViewCell {

    static let identifier = "EditEmptyCell"
    
    //@IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //infoLabel.text = "пусто"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
