//
//  AddMeasureCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 29.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class AddMeasureCell: UITableViewCell {

    static let identifier = "AddMeasureCell"
    
    @IBOutlet weak var measureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    
    func configure(subEvent: Measure) {

        numberLabel.text = subEvent.index
        nameLabel.text = subEvent.measureType?.caption
        measureImageView.contentMode = .scaleAspectFit
        if subEvent.measureType == .photo {
            if let pi = subEvent.photoImage {
                measureImageView.image = pi
                setMeasureImageView(isRounded: false)
                valueLabel.isEnabled = false
                unitLabel.isEnabled = false
                valueLabel.text = ""
                unitLabel.text = ""
                measureImageView.contentMode = .scaleAspectFill
            }else{
                fatalError("no image in photo measure!!!")
            }
        }else{
            measureImageView.image = UIImage(named: subEvent.measureType!.typeImageName)
            valueLabel.isEnabled = true
            unitLabel.isEnabled = true
            valueLabel.text = subEvent.value.formatToHumanReadableForm()
            unitLabel.text = subEvent.measureType!.unit
        }
        
        
        
        if subEvent.measureType == .photo || subEvent.measureType == .fat || subEvent.measureType == .weight || subEvent.measureType == .height {
            setMeasureImageView(isRounded: false)
        }else{
            setMeasureImageView(isRounded: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Initialization code
    }
    
    func setMeasureImageView(isRounded: Bool){
        if isRounded {
            measureImageView.layer.cornerRadius = measureImageView.frame.size.width / 2
            measureImageView.layer.borderWidth = 1
            measureImageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }else{
            measureImageView.layer.cornerRadius = measureImageView.frame.size.width / 15
            measureImageView.layer.borderWidth = 0//1
            measureImageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
