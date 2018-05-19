//
//  EditDateCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 30.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditDateCell: UITableViewCell {

    static let identifier = "EditDateCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    var date = Date()
    
    func configure(date: Date?) {
        func dateToString(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy в hh:mm"
            return formatter.string(from: date)
        }
        if let d = date{
            dateLabel.text = dateToString(date: d)
        }else{
            dateLabel.text = dateToString(date: Date())
        }
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
