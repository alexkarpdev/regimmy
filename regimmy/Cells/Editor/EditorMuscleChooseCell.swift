//
//  EditorMuscleChooseCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 13.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditorMuscleChooseCell: UITableViewCell {

    static let identifier = "EditorMuscleChooseCell"
    
    @IBOutlet weak var muscleImage: UIImageView!
    
    func configure() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        muscleImage.layer.cornerRadius = muscleImage.frame.size.width / 2
        muscleImage.layer.borderWidth = 1
        muscleImage.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        muscleImage.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
