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
    
    
    func configure() {

        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        measureImageView.layer.cornerRadius = measureImageView.frame.size.width / 2
        measureImageView.layer.borderWidth = 1
        measureImageView.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        measureImageView.clipsToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
