//
//  EditFieldCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 30.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditFieldCell: UITableViewCell {

    static let identifier = "EditFieldCell"
    
    @IBOutlet weak var textField: UITextField!
    
    func configure(placeHolder: String?, text: String?, fontSize: CGFloat?) {
        
        if let p = placeHolder {
            textField.placeholder = p
        }else{
            textField.placeholder = ""
        }
        
        if let t = text {
            textField.text = t
        }else{
            textField.text = ""
        }
        
        if let s = fontSize {
            textField.font = textField.font!.withSize(s)
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
