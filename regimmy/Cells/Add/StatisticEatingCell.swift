//
//  StatisticEatingCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 06.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class StatisticEatingCell: UITableViewCell {

    static let identifier = "StatisticEatingCell"
    
    @IBOutlet weak var protLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    func configure(with event: Eating) {
        
        protLabel.text = event.prot.formatToHumanReadableForm()
        fatLabel.text = event.fat.formatToHumanReadableForm()
        carbLabel.text = event.carb.formatToHumanReadableForm()
        calLabel.text = event.cal.formatToHumanReadableForm()
        massLabel.text = event.mass.formatToHumanReadableForm()
        
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
