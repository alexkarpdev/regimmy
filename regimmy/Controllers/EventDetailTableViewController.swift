//
//  EditEventTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 01.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EventDetailTableViewController: UITableViewController {
    
    @IBOutlet var leftButtonItem: UIBarButtonItem!
    @IBOutlet var rightButtonItem: UIBarButtonItem!
    
    var navc: UINavigationController?
    var selectedEventType: EventType!
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: EditFieldCell.identifier, bundle: nil), forCellReuseIdentifier: EditFieldCell.identifier)
        
        tableView.register(UINib(nibName: EditDateCell.identifier, bundle: nil), forCellReuseIdentifier: EditDateCell.identifier)
        tableView.register(UINib(nibName: EditRepeatCell.identifier, bundle: nil), forCellReuseIdentifier: EditRepeatCell.identifier)
        
        tableView.register(UINib(nibName: AddHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: AddHeaderCell.identifier)
        
        tableView.register(UINib(nibName: AddIngredientCell.identifier, bundle: nil), forCellReuseIdentifier: AddIngredientCell.identifier)//ingr
        tableView.register(UINib(nibName: CalendarExerciseCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarExerciseCell.identifier)//ex
        tableView.register(UINib(nibName: CalendarMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarMeasureCell.identifier)//mes/drug
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        
        tableView.tableFooterView = UIView()
        
        if (navigationController?.viewControllers.first === self) {
            setEditingMode(isEdit: true)
            navigationItem.leftBarButtonItem?.action = #selector(dismissAction(_:))
            navigationItem.leftBarButtonItem?.target = self
        }else{
            setEditingMode(isEdit: false)
        }
        
        
        
    }
    
    func setEditingMode(isEdit: Bool){
        isEditingMode = isEdit
        tableView.setEditing(isEdit, animated: true)
        setButtonItemsForEditor()
        
        isEdit ? hideTabBar() : showTabBar()
    }
    
    func setButtonItemsForEditor(){
            //tabBarController?.tabBar.isHidden = tableView.isEditing
            if tableView.isEditing == true {
                hideTabBar()
                rightButtonItem.action = #selector(saveAction)
                rightButtonItem.target = self
                rightButtonItem.title = "Сохранить"
                navigationItem.leftBarButtonItem = leftButtonItem
            }else{
                showTabBar()
                navigationItem.leftBarButtonItem = nil
                rightButtonItem.action = #selector(openForEditAction)
                rightButtonItem.target = self
                rightButtonItem.title = "Изменить"
            }
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
            return 5
        }
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
            case 1: cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
            case 2: cell = tableView.dequeueReusableCell(withIdentifier: EditDateCell.identifier, for: indexPath) as! EditDateCell
            case 3: cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath) as! EditRepeatCell
            case 4: cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath) as! EditRepeatCell
            default: cell = UITableViewCell()
            }
        }else{
            
            switch selectedEventType! {
            case .eating:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: AddIngredientCell.identifier, for: indexPath) as! AddIngredientCell
                    (cell as! AddIngredientCell).numberLabel.text = String(indexPath.row)
                }
            case .train:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: CalendarExerciseCell.identifier, for: indexPath) as! CalendarExerciseCell
                    (cell as! CalendarExerciseCell).configure()
                }
            case .measure:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewMeasure)))
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: CalendarMeasureCell.identifier, for: indexPath) as! CalendarMeasureCell
                }
            case .drugs:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: CalendarMeasureCell.identifier, for: indexPath) as! CalendarMeasureCell
                }
            }
            
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    
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
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }// Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            switch selectedEventType! {
            case .eating:
                addNewExercise()
            case .train:
                addNewExercise()
            case .measure:
                addNewMeasure()
            case .drugs:
                addNewExercise()
            }
            
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }else{
            if indexPath.row == 0 {
                return false
            }else{
                return true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    @objc func addNewExercise(){
        performSegue(withIdentifier: "IngredientsListSegue", sender: self)
    }
    @objc func addNewMeasure(){
        performSegue(withIdentifier: "MeasureChooseSegue", sender: self)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IngredientsListSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers.first as! SubEventsListTableViewController
            vc.selectedEventType = selectedEventType
            vc.navigationItem.title = "Выберите"
            vc.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openForEditAction() {
        setEditingMode(isEdit: true)
        //performSegue(withIdentifier: "IngredientsEditSegue", sender: self)
    }
    
    @objc func saveAction() {
        setEditingMode(isEdit: false)
        if navigationController?.viewControllers.first !== self {
            //navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: true){ [weak self] in
                self?.navc?.dismiss(animated: true, completion: nil)
            }
            
        }
        //performSegue(withIdentifier: "AddEditSubEventSegue", sender: self)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        setEditingMode(isEdit: false)
        //dismiss(animated: true, completion: nil)
    }
    
}
