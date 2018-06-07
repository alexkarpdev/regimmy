//
//  SmartAlertController.swift
//  regimmy
//
//  Created by Natalia Sonina on 04.06.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class SmartAlertController: UIAlertController, UITextFieldDelegate {

    var smartField = SmartField()
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        smartField.textFieldShouldClear(textField)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        smartField.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        return false
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
