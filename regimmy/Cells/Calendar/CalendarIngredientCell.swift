//
//  IngredientCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 14.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class CalendarIngredientCell: UITableViewCell {

    static let identifier = "CalendarIngredientCell"
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    func configure(subEvent: IngredientE) {
        numberLabel.text = subEvent.index
        nameLabel.text = subEvent.name
        calLabel.text = subEvent.cal.formatToHumanReadableForm()
        massLabel.text = subEvent.mass.formatToHumanReadableForm()
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
