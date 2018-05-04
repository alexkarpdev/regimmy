//
//  Extensions.swift
//  regimmy
//
//  Created by Natalia Sonina on 26.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import Foundation


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

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
