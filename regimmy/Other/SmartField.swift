//
//  NumericField.swift
//  regimmy
//
//  Created by Natalia Sonina on 04.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

protocol  SmartFieldDelegate: UITextFieldDelegate {
    func updateNumericValueBy(row: Int, text: String)
}
extension SmartFieldDelegate {
    
}
enum FieldType {
    case text, numeric
}
struct UpdatedField {
    var tag: Int
    var type: FieldType
    var field: UITextField
}

class SmartField: UITextField, UITextFieldDelegate {
    
    var smartDelegate: SmartFieldDelegate?
    var type: FieldType!
    var updatedHandler: ((String) -> ())!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if self.type == .text {
            updatedHandler("")
            smartDelegate?.updateNumericValueBy(row: textField.tag, text: "")
        }else{
            updatedHandler("0")
            smartDelegate?.updateNumericValueBy(row: textField.tag, text: "0")
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = ""
        if let t = textField.text, let textRange = Range(range, in: t) {
            if self.type == .text{
                let updatedText = t.replacingCharacters(in: textRange, with: string)
                text = updatedText
                updatedHandler(text)
                smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
            } else {
                if string == "," {
                    if t.contains(".") {
                        return false
                    }else{
                        let updatedText = t.replacingCharacters(in: textRange, with: ".")
                        text = updatedText
                        updatedHandler(text)
                        smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                    }
                } else if string == "." {
                    if (t.contains(string)) {
                        return false
                    } else if t.count < 1{
                        let updatedText = t.replacingCharacters(in: textRange, with: ".0")
                        text = updatedText
                        updatedHandler(text)
                        smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                    }else{
                        let updatedText = t.replacingCharacters(in: textRange, with: string)
                        text = updatedText
                        updatedHandler(text)
                        smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                    }
                } else if string == "0" {
                    if (t.first == "0") && !t.contains(".") {
                        return false
                    } else if (t.first == "0" && t.contains(".") && range.location < 2) {
                        return false
                    } else if (t.count > 0) && (range.location == 0) {
                        return false
                    }else{
                        let updatedText = t.replacingCharacters(in: textRange, with: string)
                        text = updatedText
                        updatedHandler(text)
                        smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                    }
                    
                } else if string == "" {
                    if (t.count < 2) {
                        let updatedText = t.replacingCharacters(in: textRange, with: "0")
                        text = updatedText
                        updatedHandler(text)
                        smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                    } else if let r1 = t.range(of: ".")?.lowerBound.encodedOffset {
                        let r2 = textRange.lowerBound.encodedOffset
                        if (t.count < 3 && r1 < r2) {
                            let updatedText = t.replacingCharacters(in: textRange, with: "0")
                            text = updatedText
                            updatedHandler(text)
                            smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                        } else {
                            let updatedText = t.replacingCharacters(in: textRange, with: string)
                            text = updatedText
                            updatedHandler(text)
                            smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                        }
                    } else {
                        let updatedText = t.replacingCharacters(in: textRange, with: string)
                        text = updatedText
                        updatedHandler(text)
                        smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                    }
                } else {
                    let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                    let compSepByCharInSet = string.components(separatedBy: aSet)
                    let numberFiltered = compSepByCharInSet.joined(separator: "")
                    if string == numberFiltered {
                        
                        if t.first == "0" && range.location > 0 {
                            let updatedText = t.replacingCharacters(in: textRange, with: string)
                            text = updatedText
                            text.removeFirst()
                            updatedHandler(text)
                            smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                        }else {
                            let updatedText = t.replacingCharacters(in: textRange, with: string)
                            text = updatedText
                            updatedHandler(text)
                            smartDelegate?.updateNumericValueBy(row: textField.tag, text: text)
                        }
                    }else{
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
}
