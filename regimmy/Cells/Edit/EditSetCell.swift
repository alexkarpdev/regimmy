//
//  EditSetCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 30.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditSetCell: UITableViewCell {

    static let identifier = "EditSetCell"
    
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var repeatCaptionLabel: UILabel!
    @IBOutlet weak var repeatValueLabel: UILabel!
    @IBOutlet weak var repeatUnitLabel: UILabel!
    
    @IBOutlet weak var loadCaptionLabel: UILabel!
    @IBOutlet weak var loadValueLabel: UILabel!
    @IBOutlet weak var loadUnitLabel: UILabel!
    
    
    func configure(set: ExerciseSet, repeatsGestureRecognizer: UITapGestureRecognizer, loadGestureRecognizer: UITapGestureRecognizer){
        indexLabel.text = "\(set.number)"
        repeatValueLabel.text = set.repeats.formatToHumanReadableForm()
        loadValueLabel.text = set.load.formatToHumanReadableForm()
        
        repeatValueLabel.tag = set.number
        repeatValueLabel.addGestureRecognizer(repeatsGestureRecognizer)
        
        loadValueLabel.tag = set.number
        loadValueLabel.addGestureRecognizer(loadGestureRecognizer)
    }
    func configure(index: Int) {
        indexLabel.text = "\(index)"
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
