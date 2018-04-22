//
//  EditRepeatCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 30.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditRepeatCell: UITableViewCell {

    static let identifier = "EditRepeatCell"
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(caption: String, detail: String) {
        captionLabel.text = caption
        detailLabel.text = detail
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
