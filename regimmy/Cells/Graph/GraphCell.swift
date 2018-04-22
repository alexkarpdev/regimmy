//
//  GraphCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 15.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
import Charts

class GraphCell: UITableViewCell, ChartViewDelegate {

    static let identifier = "GraphCell"
    
    @IBOutlet weak var chartView: LineChartView!
    func configure() {
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cc = ChartController(whith: chartView, delegate: self)
        print("hello from graphCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
