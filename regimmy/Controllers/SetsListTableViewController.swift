//
//  SetsListTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 02.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class SetsListTableViewController: UITableViewController {
    // всегда в режиме editing.
    
    var selectedTrainEvent: RootEvent!
    var selectedExercise: ExerciseE!
    var sets = [ExerciseSet]()
    var isEditingMode = false
    var showInfoCell = true
    
    
    @IBOutlet var leftButtonItem: UIBarButtonItem!
    @IBOutlet var rightButtonItem: UIBarButtonItem!

    var complitionHandler: ((ExerciseE)->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: EditFieldCell.identifier, bundle: nil), forCellReuseIdentifier: EditFieldCell.identifier)
        
        tableView.register(UINib(nibName: AddHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: AddHeaderCell.identifier)
        tableView.register(UINib(nibName: EditSetCell.identifier, bundle: nil), forCellReuseIdentifier: EditSetCell.identifier)
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        
        tableView.tableFooterView = UIView()
        
        tableView.isEditing = true
        
        sets = selectedExercise.subEvents as! [ExerciseSet]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1 + sets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
            cell.accessoryType = .detailButton
            (cell as! EditFieldCell).configure(placeHolder: "Название", text: selectedExercise.name, tag: 0, fieldIsEnabled: false)
                
            case 1: cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
            cell.accessoryType = .none
            (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: selectedExercise.info, tag: 1, fieldIsEnabled: false, fontSize: 15)
                
            default: cell = UITableViewCell()
            }
        }else{
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                (cell as! AddHeaderCell).captionLabel.text = "Подходы"
                (cell as! AddHeaderCell).rotateArrow()
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: EditSetCell.identifier, for: indexPath) as! EditSetCell
                (cell as! EditSetCell).indexLabel.text = String(indexPath.row)
            }
            
        }
        return cell
        
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0{
            return .none
        }else{
            if indexPath.row == 0 {
                return .insert
            }else{
                return .delete
            }
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }// Return false if you do not want the specified item to be editable.
        return true
    }
 
//    @objc func addNewSet() {
//
//    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            sets.append(ExerciseSet())
            tableView.reloadSections([1], with: .automatic)
            //tableView.insertRows(at: <#T##[IndexPath]#>, with: <#T##UITableViewRowAnimation#>)
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        selectedExercise.subEvents = sets
        complitionHandler(selectedExercise)
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) { // cancel from editing
        selectedExercise.backup()
        dismiss(animated: true, completion: nil)
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
