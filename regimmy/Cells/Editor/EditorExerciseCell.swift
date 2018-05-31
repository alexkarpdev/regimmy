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
        
        typeLabel.text = posObject.type!.rawValue
        durationLabel.text = posObject.durationType.rawValue
        loadLabel.text = posObject.loadUnit.rawValue
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        muscleImageView.layer.cornerRadius = muscleImageView.frame.size.width / 2
        muscleImageView.layer.borderWidth = 1
        muscleImageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        muscleImageView.clipsToBounds = true
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
