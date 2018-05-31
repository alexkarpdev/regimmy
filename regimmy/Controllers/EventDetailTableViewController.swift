//
//  EditEventTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 01.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
import RealmSwift

class EventDetailTableViewController: UITableViewController {
    
    @IBOutlet var leftButtonItem: UIBarButtonItem!
    @IBOutlet var rightButtonItem: UIBarButtonItem!
    
    var navc: UINavigationController?
    
    var selectedEventType: EventType!
    
    var isEditingMode = false
    var isCreateNew = false
    
    //var selectedEvent: RBaseEvent!
    var selectedPoso: RootEvent!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedEventType = selectedPoso.type
        
        tableView.register(UINib(nibName: EditFieldCell.identifier, bundle: nil), forCellReuseIdentifier: EditFieldCell.identifier)
        
        tableView.register(UINib(nibName: EditDateCell.identifier, bundle: nil), forCellReuseIdentifier: EditDateCell.identifier)
        tableView.register(UINib(nibName: EditRepeatCell.identifier, bundle: nil), forCellReuseIdentifier: EditRepeatCell.identifier)
        
        tableView.register(UINib(nibName: AddHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: AddHeaderCell.identifier)
        
        tableView.register(UINib(nibName: AddIngredientCell.identifier, bundle: nil), forCellReuseIdentifier: AddIngredientCell.identifier)//ingr
        tableView.register(UINib(nibName: CalendarExerciseCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarExerciseCell.identifier)//ex
        tableView.register(UINib(nibName: AddMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: AddMeasureCell.identifier)//mes/drug
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        
        tableView.tableFooterView = UIView()
        
        isCreateNew = navigationController?.viewControllers.first === self ? true : false
        
        if isCreateNew {
            setEditingMode(isEdit: true)
            navigationItem.leftBarButtonItem?.action = #selector(dismissAction(_:))
            navigationItem.leftBarButtonItem?.target = self
            navigationItem.title = "Новую " + selectedEventType.name
        }else{
            setEditingMode(isEdit: false)
            navigationItem.title = selectedEventType.name
        }
        
    }
    
    func setEditingMode(isEdit: Bool){
        isEditingMode = isEdit
        
        if isEditingMode {
            tableView.insertSections([2], with: .automatic)
            
        } else {
            if tableView.numberOfSections > 2 {
                tableView.deleteSections([2], with: .automatic)
                
            }
        }
        
        tableView.setEditing(isEdit, animated: true)
        setButtonItemsForEditor()
        
        isEdit ? hideTabBar() : showTabBar()
        
        tableView.reloadSections([0], with: .automatic)
        
        if let field = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditFieldCell)?.textField {
            field.isEnabled = isEdit
            isEditing ? field.becomeFirstResponder() : field.resignFirstResponder()
        }
        if let field = (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditFieldCell)?.textField {
            field.isEnabled = isEdit
        }
        if let cell = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? AddHeaderCell) {
            cell.contentView.isUserInteractionEnabled = isEdit
        }
        
        tableView.allowsSelection = isEdit
        
       
        
        
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
        return (isEditingMode && !isCreateNew) ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else if section == 2 {
            return 1
        } else {
            var count = 1
            count += selectedPoso.subEvents.count
           return count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: selectedPoso.name, fontSize: 17)
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: selectedPoso.info, fontSize: 15)
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditDateCell.identifier, for: indexPath) as! EditDateCell
                (cell as! EditDateCell).configure(date: selectedPoso.date)
                cell.selectionStyle = .default// isEditingMode ? .default : .none
                cell.accessoryType = tableView.isEditing ? .disclosureIndicator : .none
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath) as! EditRepeatCell
                (cell as! EditRepeatCell).configure(caption: "Повторить", detail: "нет")
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = tableView.isEditing ? .disclosureIndicator : .none
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath) as! EditRepeatCell
                (cell as! EditRepeatCell).configure(caption: "Напомнить", detail: "нет")
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = tableView.isEditing ? .disclosureIndicator : .none
            default:
                cell = UITableViewCell()
            }
        } else if indexPath.section == 1 {
            
            switch selectedEventType! {
            case .eating:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                    (cell as! AddHeaderCell).captionLabel.text = "Ингредиенты"
                    (cell as! AddHeaderCell).rotateArrow()
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: AddIngredientCell.identifier, for: indexPath) as! AddIngredientCell
                    (cell as! AddIngredientCell).numberLabel.text = String(indexPath.row)
                }
            case .train:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                    (cell as! AddHeaderCell).captionLabel.text = "Упражнения"
                    (cell as! AddHeaderCell).rotateArrow()
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: CalendarExerciseCell.identifier, for: indexPath) as! CalendarExerciseCell
                    (cell as! CalendarExerciseCell).configure()
                }
            case .measure:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewMeasure)))
                    (cell as! AddHeaderCell).captionLabel.text = "Измерения"
                    (cell as! AddHeaderCell).rotateArrow()
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: AddMeasureCell.identifier, for: indexPath) as! AddMeasureCell
                }
            case .drugs:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                    (cell as! AddHeaderCell).captionLabel.text = "Препараты"
                    (cell as! AddHeaderCell).rotateArrow()
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: AddMeasureCell.identifier, for: indexPath) as! AddMeasureCell
                }
            }
            cell.selectionStyle = .none
        } else if indexPath.section == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
            (cell as! EditFieldCell).configure(placeHolder: "", text: "Удалить событие", fontSize: 17)
            (cell as! EditFieldCell).textField.isEnabled = false
            (cell as! EditFieldCell).textField.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            (cell as! EditFieldCell).textField.textAlignment = .center
        } else {
            cell = UITableViewCell()
            fatalError("no case for cell!!")
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0{
            return .none
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return .insert
            }else{
                return .delete
            }
        }else{
             return .none
        }
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 || indexPath.section == 2{
            return false
        }// Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedPoso.removeSubEvent(at: indexPath.row - 1)
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
        if indexPath.section == 0 {
            switch indexPath.row {
            case 2:
                performSegue(withIdentifier: "ShowCalendarSegue", sender: self)
            default:
                break
            }
        }else if indexPath.section == 1 {
            
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCalendarSegue" {
            hideTabBar()
            (segue.destination as! CalendarViewController).selectedDate = selectedPoso.date
            (segue.destination as! CalendarViewController).isPickerHidden = false
            (segue.destination as! CalendarViewController).completion = { [unowned self](selectedDate: Date) in
                
                self.showTabBar()
                self.updateDateOn(selectedDate: selectedDate)
                print(selectedDate)
            }
        }
        
        if segue.identifier == "IngredientsListSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers.first as! SubEventsListTableViewController
            vc.selectedSubEventType = selectedEventType.subEventType
            vc.navigationItem.title = "Выберите"
            vc.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func updateDateOn(selectedDate: Date){
        selectedPoso.date = selectedDate
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        //topDateLabel.text = selectedDate.description(with: Locale(identifier: "ru-RU"))
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openForEditAction() {
        setEditingMode(isEdit: true)
        //performSegue(withIdentifier: "IngredientsEditSegue", sender: self)
    }
    
    @objc func saveAction() {
        
        selectedPoso.saveToDB()
        
        setEditingMode(isEdit: false)
        
        if !isCreateNew {
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
        selectedPoso.backup()
        tableView.reloadSections([0], with: .automatic)
        //dismiss(animated: true, completion: nil)
    }
    
}

extension EventDetailTableViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateFieldFor(row: textField.tag, text: "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = ""
        if let t = textField.text,
            let textRange = Range(range, in: t) {
            let updatedText = t.replacingCharacters(in: textRange, with: string)
            text = updatedText
            updateFieldFor(row: textField.tag, text: text)
        }
        return true
    }
    
    func updateFieldFor(row: Int, text: String) {
        switch row
        {
        case 0:
            selectedPoso.name = text
        case 1:
            selectedPoso.info = text
        default:
            print("It is nothing");
        }
    }
    
}
























