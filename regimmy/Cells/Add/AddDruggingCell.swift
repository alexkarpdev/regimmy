//
//  AddDrugsCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 29.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class AddDruggingCell: UITableViewCell {

    static let identifier = "AddDruggingCell"
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configure(with event:SimpleEvent) {
        
        typeImageView.image = event.type.image
        timeLabel.text = "" + event.dateTime + "   "
        nameLabel.text = event.name
        
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
