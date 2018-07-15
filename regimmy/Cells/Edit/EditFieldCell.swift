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
    
    @IBOutlet weak var textField: SmartField!
    
    func configure(placeHolder: String?, text: String?, tag: Int, fieldIsEnabled: Bool, fontSize: CGFloat = 17.0) {
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
        
        textField.font = textField.font!.withSize(fontSize)
        
        textField.tag = tag
        textField.isEnabled = fieldIsEnabled
    }
    
    func configure(placeHolder: String?, text: String?, tag: Int, fieldIsEnabled: Bool, fontSize: CGFloat = 17.0, updatedHandler: @escaping (String)->()) {
        
        self.configure(placeHolder: placeHolder, text: text, tag: tag, fieldIsEnabled: fieldIsEnabled)
        
        textField.updatedHandler = updatedHandler
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.type = .text
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
