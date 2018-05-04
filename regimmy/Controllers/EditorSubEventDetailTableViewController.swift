//
//  EditorEditSubeventTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 13.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EditorSubEventDetailTableViewController: UITableViewController {

    var selectedSubEventType: SubEventType!
    
    @IBOutlet weak var leftButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.register(UINib(nibName: EditFieldCell.identifier, bundle: nil), forCellReuseIdentifier: EditFieldCell.identifier)
        tableView.register(UINib(nibName: EditorDescriptionCell.identifier, bundle: nil), forCellReuseIdentifier: EditorDescriptionCell.identifier)
        tableView.register(UINib(nibName: EditRepeatCell.identifier, bundle: nil), forCellReuseIdentifier: EditRepeatCell.identifier)
        tableView.register(UINib(nibName: EditorMuscleChooseCell.identifier, bundle: nil), forCellReuseIdentifier: EditorMuscleChooseCell.identifier)
        tableView.register(UINib(nibName: EditorNutrientCell.identifier, bundle: nil), forCellReuseIdentifier: EditorNutrientCell.identifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSubEventType! {
        case .exercise:
            return 6
        case .ingredient:
            return 6
        case .drug:
            return 4
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!

        switch selectedSubEventType! {
        case .exercise:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorDescriptionCell.identifier, for: indexPath)
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: "Тип нагрузки", detail: "силовая")
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: "Продолжительность", detail: "повторы")
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: "Нагрузка", detail: "кг")
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorMuscleChooseCell.identifier, for: indexPath)
            default:
                cell = UITableViewCell()
            }
        case .ingredient:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorDescriptionCell.identifier, for: indexPath)
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Белки", value: nil, unit: "грамм", color: #colorLiteral(red: 0.1058823529, green: 0.6784313725, blue: 0.9725490196, alpha: 1))
                
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Жиры", value: nil, unit: "грамм", color: #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1))
                
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Углеводы", value: nil, unit: "грамм", color: #colorLiteral(red: 0.3882352941, green: 0.8549019608, blue: 0.2196078431, alpha: 1))
                
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Энерг.", value: nil, unit: "ккал.", color: #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1))
                
            default:
                cell = UITableViewCell()
            }
        case .drug:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorDescriptionCell.identifier, for: indexPath)
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: "Ед. измерения", detail: "грамм")
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Размер порции", value: nil, unit: "грамм", color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            default:
                cell = UITableViewCell()
            }
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedSubEventType! {
        case .exercise:
            if indexPath.row == 5 {
                performSegue(withIdentifier: "MuscleChooseSegue", sender: self)
            }
        case .ingredient:
            break
        case .drug:
            break
        }
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

     @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
     }
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
