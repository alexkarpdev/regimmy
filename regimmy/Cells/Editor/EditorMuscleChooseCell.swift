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
    
    @IBOutlet weak var muscleImageView: UIImageView!
    
    @IBOutlet weak var muscleImageConstraint: NSLayoutConstraint!
    
    func changeConstraintFor(edit:Bool) {
        UIView.animate(withDuration: 0.1) {
            self.muscleImageConstraint.constant = edit ? 0 : 16
            self.layoutSubviews()
        }
    }
    
    func configure() {
        
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
