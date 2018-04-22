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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
