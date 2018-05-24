//
//  EditorExerciseCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 20.05.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditorExerciseCell: UITableViewCell {

    static let identifier = "EditorExerciseCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var muscleImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var loadLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(posObject: Exercise){
        
        nameLabel.text = posObject.name
        
        infoLabel.isEnabled = !posObject.info.isEmpty
        infoLabel.text = posObject.info
        
        if let mi = posObject.muscle {
            muscleImageView.image = UIImage(named: mi.typeImageName)
            muscleImageView.alpha = 1
        }else{
            muscleImageView.alpha = 0.3
        }
        
        typeLabel.text = posObject.type.rawValue
        durationLabel.text = posObject.durationType.rawValue
        loadLabel.text = posObject.loadUnit.rawValue
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
