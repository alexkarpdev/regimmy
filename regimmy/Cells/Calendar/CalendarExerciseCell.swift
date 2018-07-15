//
//  ExerciseCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 14.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
import Foundation

class CalendarExerciseCell: UITableViewCell {
    
    static let identifier = "CalendarExerciseCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setIndexLabel: UILabel!
    @IBOutlet weak var repeatsValueLabel: UILabel!
    @IBOutlet weak var loadValueLabel: UILabel!
    @IBOutlet weak var repeatsUnitLabel: UILabel!
    @IBOutlet weak var loadUnitLabel: UILabel!
    
    func configure(exercise: ExerciseE) {
        nameLabel.text = exercise.name
        
    }
    
    func configure() {
        setIndexLabel.text = "1\n2\n3"
        repeatsValueLabel.text = "10\n12\n13"
        loadValueLabel.text = "100\n102\n113"
        
        let attributedString = NSMutableAttributedString(string: "кг.\nкг.\nкг.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        //label.attributedText = attributedString;
        
        repeatsUnitLabel.attributedText = attributedString
        loadUnitLabel.attributedText = attributedString
        
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
