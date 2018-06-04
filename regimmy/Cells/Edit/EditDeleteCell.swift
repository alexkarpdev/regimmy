//
//  EditDeleteCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 31.05.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditDeleteCell: UITableViewCell {

    static let identifier = "EditDeleteCell"
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.text = "Удалить событие"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
