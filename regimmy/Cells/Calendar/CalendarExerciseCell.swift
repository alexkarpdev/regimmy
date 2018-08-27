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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var exerciseIndexLabel: UILabel!
    @IBOutlet weak var muscleGroupImageView: UIImageView!
    @IBOutlet weak var setIndexLabel: UILabel!
    @IBOutlet weak var repeatsValueLabel: UILabel!
    @IBOutlet weak var loadValueLabel: UILabel!
    @IBOutlet weak var repeatsUnitLabel: UILabel!
    @IBOutlet weak var loadUnitLabel: UILabel!
    
    func configure(exercise: ExerciseE) {
        nameLabel.text = exercise.name
        
        infoLabel.isEnabled = !exercise.info.isEmpty
        infoLabel.text = exercise.info
        
        exerciseIndexLabel.text = exercise.index
        
        if let mi = exercise.muscle {
            muscleGroupImageView.image = UIImage(named: mi.typeImageName)
            muscleGroupImageView.alpha = 1
        }else{
            muscleGroupImageView.alpha = 0.3
        }
        
        let durationUnit = exercise.durationType.unit
        let loadUnit = exercise.loadUnitType.unit
        
        var setIndex = ""
        var repeatsValue = ""
        var loadValue = ""
        
        var repeatsUninString = ""
        var loadUnitString = ""
        
        if exercise.subEvents.count == 0 {
            setIndex = "-"
            repeatsValue = "-"
            loadValue = "-"
        }else{
            
            for set in (exercise.subEvents as! [ExerciseSet]) {
                let sln = set.number == exercise.subEvents.count ? "" : "\n"
                setIndex += "\(set.number)" + sln
                repeatsValue += (set.repeats.formatToHumanReadableForm() + sln)
                loadValue += (set.load.formatToHumanReadableForm() + sln)
                
                repeatsUninString += durationUnit + sln
                loadUnitString += loadUnit + sln
            }
        }
        
        setIndexLabel.text = setIndex
        repeatsValueLabel.text = repeatsValue
        loadValueLabel.text = loadValue
        
        let repeatUnitrAttributedString = NSMutableAttributedString(string: repeatsUninString)
        let loadUnitAttributedString = NSMutableAttributedString(string: loadUnitString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        repeatUnitrAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, repeatUnitrAttributedString.length))
        loadUnitAttributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, loadUnitAttributedString.length))
        
        repeatsUnitLabel.attributedText = repeatUnitrAttributedString
        loadUnitLabel.attributedText = loadUnitAttributedString
        
    }
    
    func configure() {
        setIndexLabel.text = "1\n2\n3"
        repeatsValueLabel.text = "10\n12\n13"
        loadValueLabel.text = "100\n102\n113"
        
        let attributedString = NSMutableAttributedString(string: "кг.\nкг.\nкг.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        repeatsUnitLabel.attributedText = attributedString
        loadUnitLabel.attributedText = attributedString
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        muscleGroupImageView.layer.cornerRadius = muscleGroupImageView.frame.size.width / 2
        muscleGroupImageView.layer.borderWidth = 1
        muscleGroupImageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        muscleGroupImageView.clipsToBounds = true
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
