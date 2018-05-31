//
//  Extensions.swift
//  regimmy
//
//  Created by Natalia Sonina on 26.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation

// MARK: - String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    
}

// MARK: - Double
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> String {
        let divisor = pow(10.0, Double(places))
        var res:Double
        if self >= 1000{
            res  = (self / 1000 * divisor).rounded() / divisor
            if (res - Double(Int(res)) == 0){
                
                print(String.init(format: "%.0f", (self/1000 * divisor).rounded() / divisor))
                return String.init(format: "%.0fK", (self/1000 * divisor).rounded() / divisor)
                
            }
            return String.init(format: "%.1fK", (self/1000 * divisor).rounded() / divisor)
        }
        res  = (self * divisor).rounded() / divisor
        if (res - Double(Int(res)) == 0){
            return String.init(format: "%.0f", res)
        }
        return String.init(format: "%.1f", res)
    }
}

extension Double {
    func formatToHumanReadableForm() -> String {
        guard self > 0 else {
            return "0"
        }
        let suffixes = ["", "K", "M", "G", "TB", "PB", "EB", "ZB", "YB"]
        let k: Double = 1000
        var i = floor(log(self) / log(k))
        i = i < 0 ? 0 : i
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = i == 0 ? 1 : 0
        numberFormatter.numberStyle = .decimal
        
        let numberString = numberFormatter.string(from: NSNumber(value: self / pow(k, i))) ?? "Unknown"
        let suffix = suffixes[Int(i)]
        return "\(numberString)\(suffix)"
    }
}

// MARK: - UIViewController
extension UIViewController {
    func hideTabBar() {
        if var frame = self.tabBarController?.tabBar.frame {
            frame.origin.y = self.view.frame.size.height// + (frame?.size.height)!
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame = frame
            }, completion: nil)
        }
    }
    
    func showTabBar() {
        if var frame = self.tabBarController?.tabBar.frame {
            frame.origin.y = self.view.frame.size.height - (frame.size.height)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.tabBarController?.tabBar.frame = frame
            }, completion: nil)
        }
    }
}

// MARK: - UITextView
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
