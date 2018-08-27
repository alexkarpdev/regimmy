//
//  EditSupersetCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 25.08.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditSupersetCell: UITableViewCell {
    
    static let identifier = "EditSupersetCell"
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    

    func configure(caption: String, detail: String, isOpen: Bool) {
        captionLabel!.text = caption
        detailLabel!.text = detail
        
        rotateArrow(isOpen: isOpen)
        
    }
    
    func rotateArrow(isOpen: Bool){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            if isOpen == true {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            }else{
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            }
            }, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            setSelected(false, animated: true)
        }
        
        // Configure the view for the selected state
    }
    
}
