//
//  AddHeaderCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 29.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class AddHeaderCell: UITableViewCell {
    
    static let identifier = "AddHeaderCell"
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    func configure() {
        
    }
    
    func rotateArrow(){
        arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
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
