//
//  EditorDrugCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 20.05.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditorDrugCell: UITableViewCell {

    static let identifier = "EditorDrugCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
