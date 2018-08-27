//
//  CalendarEatingHeaderCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 28.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class CalendarEatingHeaderCell: UITableViewCell {
    
    static let identifier = "CalendarEatingHeaderCell"
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var protLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    func configure(with event: Eating) {
        
        typeImageView.image = event.type!.image
        timeLabel.text = event.time
        nameLabel.text = event.name
        
        infoLabel.isEnabled = !event.info.isEmpty
        infoLabel.text = event.info
        
        protLabel.text = event.prot.formatToHumanReadableForm()
        fatLabel.text = event.fat.formatToHumanReadableForm()
        carbLabel.text = event.carb.formatToHumanReadableForm()
        calLabel.text = event.cal.formatToHumanReadableForm()
        massLabel.text = event.mass.formatToHumanReadableForm()
        
        self.contentView.backgroundColor = event.type?.sectionColor
        
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
