//
//  SetSupersetCell.swift
//  regimmy
//
//  Created by Natalia Sonina on 16.07.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class SetSupersetCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    
    static let identifier = "SetSupersetCell"
    
    let numbersAr = Array.init(0...9)
    let lettersAr: [String] = ["_", "A", "B", "C", "D", "E", "F", "G"]
    
    var updateIndexHandler: ((String, String) -> ())!
    
    var setRow = 0
    var supersetRow = 0
    
    @IBOutlet weak var indexPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indexPicker.delegate = self
        indexPicker.dataSource = self
        // Initialization code
    }
    
    func configure(index: (set: String, superset: String), updateIndexHandler: @escaping ((String, String) -> ())) {
        self.updateIndexHandler = updateIndexHandler
        
        setRow = numbersAr.index(of: Int(index.set)!)!
        supersetRow = lettersAr.index(of: (index.superset == "" ? "_" : index.superset))!
        
        indexPicker.selectRow(setRow, inComponent: 0, animated: true)
        indexPicker.selectRow(supersetRow, inComponent: 1, animated: true)
      
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(numbersAr[row])"
        }
        return lettersAr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            setRow = row
        }else {
            supersetRow = row
        }
        updateIndexHandler("\(numbersAr[setRow])", lettersAr[supersetRow])
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return numbersAr.count
        }
        return lettersAr.count
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
