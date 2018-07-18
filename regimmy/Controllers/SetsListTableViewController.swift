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
    
    var updateIndexHandler: ((String, String) -> ())!
    
    var index: (set: String, superset: String)! = (set: "", superset: "") {
        didSet{
            //if self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) != nil {
                //self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
            //}
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: EditFieldCell.identifier, bundle: nil), forCellReuseIdentifier: EditFieldCell.identifier)
        tableView.register(UINib(nibName: EditRepeatCell.identifier, bundle: nil), forCellReuseIdentifier: EditRepeatCell.identifier)
        tableView.register(UINib(nibName: SetSupersetCell.identifier, bundle: nil), forCellReuseIdentifier: SetSupersetCell.identifier)
        
        tableView.register(UINib(nibName: AddHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: AddHeaderCell.identifier)
        tableView.register(UINib(nibName: EditSetCell.identifier, bundle: nil), forCellReuseIdentifier: EditSetCell.identifier)
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        
        tableView.tableFooterView = UIView()
        
        tableView.isEditing = true
        
        sets = selectedExercise.subEvents as! [ExerciseSet]
        
        
        let ses = selectedExercise.index.components(separatedBy: "-")
        let s = ses.first!
        let ss = ses.count > 1 ? ses[1] : ""
        
        index = (set: s, superset: ss)
        
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
            return 4
        }
        return 1 + sets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
                cell.accessoryType = .detailButton
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: selectedExercise.name, tag: 0, fieldIsEnabled: false)
                
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
                cell.accessoryType = .none
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: selectedExercise.info, tag: 1, fieldIsEnabled: false, fontSize: 15)
                
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath) as! EditRepeatCell
                (cell as! EditRepeatCell).configure(caption: "Сет-суперсет", detail: (index.set + (index.superset == "" ? "" : "-" + index.superset)))
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: SetSupersetCell.identifier, for: indexPath) as! SetSupersetCell
                (cell as! SetSupersetCell).configure(index: index){ [unowned self] set, superset in
                    self.index = (set: set, superset: superset == "_" ? "" : superset)
                    self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                }
            default: cell = UITableViewCell()
            }
        }else{
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                (cell as! AddHeaderCell).captionLabel.text = "Подходы"
                (cell as! AddHeaderCell).rotateArrow()
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: EditSetCell.identifier, for: indexPath) as! EditSetCell
                let repeatsGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnRepeatsLabel(sender:)))
                let loadGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnLoadLabel(sender:)))
                (cell as! EditSetCell).configure(set: sets[indexPath.row - 1], repeatsGestureRecognizer: repeatsGestureRecognizer, loadGestureRecognizer: loadGestureRecognizer)
            }
            
        }
        return cell
        
    }
    
    
    @objc func tapOnRepeatsLabel(sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        callSmartAlert(caption: "Число повторов", row: tag) { [unowned self] value in
            self.sets[tag - 1].repeats = value
        }
    }
    @objc func tapOnLoadLabel(sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        callSmartAlert(caption: "Величина нагрузки", row: tag) { [unowned self] value in
            self.sets[tag - 1].load = value
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 2, section: 0) {
            
        }
    }
 
//    @objc func addNewSet() {
//
//    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sets.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            let number = sets.count + 1
            sets.append(ExerciseSet(number: number))
            //tableView.reloadSections([1], with: .automatic)
            tableView.insertRows(at: [IndexPath(row: number, section: 1)], with: .automatic)
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        selectedExercise.index = (index.set + "-" + index.superset)
        selectedExercise.subEvents = sets
        complitionHandler(selectedExercise)
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) { // cancel from editing
        if selectedExercise.object != nil {
            selectedExercise.backup()
        }
        dismiss(animated: true, completion: nil)
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        sets.insert(sets.remove(at: sourceIndexPath.row - 1), at: destinationIndexPath.row - 1)
        
        var number = 1
        for s in sets {
            s.number = number
            number += 1
        }
        
        let dispatchTime = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.tableView.reloadSections([1], with: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let row = proposedDestinationIndexPath.row
        let section = proposedDestinationIndexPath.section
        if section == 1{
            if row == 0 {
                return IndexPath(row: proposedDestinationIndexPath.row + 1, section: 1)
            }
            return IndexPath(row: proposedDestinationIndexPath.row, section: 1)
        }
        return IndexPath(row: 1, section: 1)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && indexPath.row != 0 {
            return true
        }
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func callSmartAlert(caption: String, row: Int, updateAction: @escaping (Double)->()){
        let ac = SmartAlertController(title: caption, message: "в подходе №\(row)", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?.first?.keyboardType = .decimalPad
        ac.textFields?.first?.keyboardAppearance = .alert
        var value = 0.0
        ac.smartField.updatedHandler = { t in
            value = Double(t)!
            if let selectedRange = ac.textFields?.first?.selectedTextRange {
                let cursorPosition = ac.textFields?.first?.offset(from: (ac.textFields?.first?.beginningOfDocument)!, to: selectedRange.start)
                print("\(cursorPosition)")
                let locale = NSLocale.autoupdatingCurrent
                let separator = locale.decimalSeparator
                let text = t.replacingOccurrences(of: ".", with: separator!)
                ac.textFields?.first?.text = text
                let add = (ac.textFields?.first?.text?.count)! < t.count ? 0 : 1
                if let newPosition = ac.textFields?.first?.position(from: (ac.textFields?.first?.beginningOfDocument)!, offset: cursorPosition! + add) {
                    ac.textFields?.first?.selectedTextRange = ac.textFields?.first?.textRange(from: newPosition, to: newPosition)
                }
            }
            print( "t : \(t)")
        }
        ac.smartField.type = .numeric
        ac.textFields?.first?.delegate = ac
        let submitAction = UIAlertAction(title: "Добавить", style: .default) { [unowned ac, self] _ in
            updateAction(value)
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 1)], with: .automatic)
            // do something interesting with "answer" here
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }

}
