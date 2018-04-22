//
//  AddEventCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 29.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class AddEventCell: UITableViewCell {

    static let identifier = "AddEventCell"
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configure(with type: EventType) {
        
        typeImageView.image = type.image
        nameLabel.text = type.name
        
    }
    
    func configure(with type: SubEventType) {
        
        typeImageView.image = type.image
        nameLabel.text = type.name
        
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
