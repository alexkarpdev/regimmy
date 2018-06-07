//
//  AddIngredientCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 28.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class AddIngredientCell: UITableViewCell {

    static let identifier = "AddIngredientCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var protLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var nameLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    func configure(subEvent: IngredientE) {
        numberLabel.text = subEvent.index
        nameLabel.text = subEvent.name
        protLabel.text = subEvent.prot.formatToHumanReadableForm()
        fatLabel.text = subEvent.fat.formatToHumanReadableForm()
        carbLabel.text = subEvent.carb.formatToHumanReadableForm()
        calLabel.text = subEvent.cal.formatToHumanReadableForm()
        massLabel.text = subEvent.mass.formatToHumanReadableForm()

    }
    
    // don't used
    func configure(name: String, prot: Double, fat: Double, carb: Double, cal: Double, mass: Double = 100, number: Double = 0){
        
        self.nameLabel.text = name
        self.protLabel.text = String(prot)
        self.fatLabel.text = String(fat)
        self.carbLabel.text = String(carb)
        self.calLabel.text = String(cal)
        self.massLabel.text = String(mass)
        self.numberLabel.text = String(number)
        //nameLabel.autoresizingMask = [.flexibleWidth, .flexibleRightMargin]
       // nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin
        if (self.selectionStyle == .none) {
                        nameLabelConstraint.constant = (self.contentView.frame.width - 33 - 16)
                    }else{
                        nameLabelConstraint.constant = (self.contentView.frame.width - 33 - 16 - 43 - 52 - 120)
                    }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("layout name:\(nameLabel.text)")
//        print("layout h:\(nameLabel.frame.height)")
//        print("layout w:\(nameLabel.frame.width)")
        //        print("layout a:\(self.accessoryType.rawValue)")
        //        nameLabel.sizeToFit()
//        if (self.selectionStyle == .none) {
//            nameLabelConstraint.constant = (self.contentView.frame.width - 33 - 16)
//        }else{
//            nameLabelConstraint.constant = (self.contentView.frame.width - 33 - 16 - 43 - 52)
//        }
//        nameLabelConstraint.constant = (self.contentView.frame.width - 33 - 16)
//        super.layoutSubviews()
        //self.contentView.layoutIfNeeded()
        //self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         //layoutSubviews()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
