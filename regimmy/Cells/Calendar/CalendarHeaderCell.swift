//
//  CalendarHeaderCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 13.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class CalendarHeaderCell: UITableViewCell {
    
    static let identifier = "CalendarHeaderCell"

    @IBOutlet weak var topDateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
