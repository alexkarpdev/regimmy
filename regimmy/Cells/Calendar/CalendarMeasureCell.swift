//
//  CalendarMeasureCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 29.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class CalendarMeasureCell: UITableViewCell {

    static let identifier = "CalendarMeasureCell"
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure() {
        
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
