//
//  MeasureChooseViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 11.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class MeasureChooseViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet var measureButtons: [MuscleButton]!
    
    var selectedMeasure: [MeasureType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        measureButtons.map{$0.addTarget(self, action: #selector(addMeasure(_:)), for: .touchUpInside)}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addMeasure(_ sender: MuscleButton){
        
        if let mes = (selectedMeasure.filter{$0.rawValue == sender.imageName}).first {
            selectedMeasure.remove(at: selectedMeasure.index(of: mes)!)
            sender.setImage(UIImage(named: "Add"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
        }else{
            selectedMeasure.append(MeasureType(rawValue: sender.imageName)!)
            sender.setImage(UIImage(named: "Remove"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
        
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
