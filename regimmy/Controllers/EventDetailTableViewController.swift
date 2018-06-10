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
    
    let nameCellRow = 0
    let infoCellRow = 1
    
    let calendarCellRow = 2
    let repeatCellRow = 3
    let notifyCellRow = 4
    let statisticCellRow = 5
    
    let addSubEventCellRow = 0 //section 1
    let removeEventCellRow = 0 //section 2
    
    var showedRows = [Int]()
    
    var showDeleteCell = false
    
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
        tableView.register(UINib(nibName: AddMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: AddMeasureCell.identifier)//mes
        tableView.register(UINib(nibName: AddDrugCell.identifier, bundle: nil), forCellReuseIdentifier: AddDrugCell.identifier)//drug
        
        tableView.register(UINib(nibName: EditDeleteCell.identifier, bundle: nil), forCellReuseIdentifier: EditDeleteCell.identifier)
        
        tableView.register(UINib(nibName: EditEmptyCell.identifier, bundle: nil), forCellReuseIdentifier: EditEmptyCell.identifier)
        
        tableView.register(UINib(nibName: StatisticEatingCell.identifier, bundle: nil), forCellReuseIdentifier: StatisticEatingCell.identifier)
        tableView.register(UINib(nibName: StatisticDrugCell.identifier, bundle: nil), forCellReuseIdentifier: StatisticDrugCell.identifier)
        tableView.register(UINib(nibName: StatisticMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: StatisticMeasureCell.identifier)
        tableView.register(UINib(nibName: StatisticTrainCell.identifier, bundle: nil), forCellReuseIdentifier: StatisticTrainCell.identifier)
        
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
        
        tableView.reloadSections([0,1], with: .none)
        
        showDeleteCell = isEditingMode && !isCreateNew
        
        if !isCreateNew {
            if isEditingMode {
                tableView.insertSections([2], with: .automatic)
                
            } else {
                if tableView.numberOfSections > 2 {
                    tableView.deleteSections([2], with: .automatic)
                    
                }
            }
        }
        
        tableView.setEditing(isEdit, animated: true)
        setButtonItemsForEditor()
        
        isEdit ? hideTabBar() : showTabBar()
        
        tableView.allowsSelection = isEdit
        
//        let dispatchTime = DispatchTime.now() + 1.6
//        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
//            self.tableView.reloadSections([1], with: .none)
//            print("reloaded")
//        }
        //tableView.reloadSections([1], with: .none)
        
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
        return showDeleteCell ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            showedRows.removeAll()
            showedRows.append(nameCellRow)
            if (!selectedPoso.info.isEmpty || isEditingMode) {showedRows.append(infoCellRow)}
            showedRows.append(calendarCellRow)
            if (isEditingMode) {showedRows.append(repeatCellRow)}
            if (isEditingMode) {showedRows.append(notifyCellRow)}
            showedRows.append(statisticCellRow)
            return showedRows.count
        } else if section == 2 {
            return 1
        } else {
            var count = 1
            count += selectedPoso.subEvents.count == 0 ? 1 : selectedPoso.subEvents.count
            return count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        if indexPath.section == 0 {
            
            let row = showedRows[indexPath.row]
            
            switch row{
            case nameCellRow:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: selectedPoso.name, tag: indexPath.row, fieldIsEnabled: isEditingMode, fontSize: 17) { t in
                    self.selectedPoso.name = t
                }
                cell.selectionStyle = .none
            case infoCellRow:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath) as! EditFieldCell
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: selectedPoso.info, tag: indexPath.row, fieldIsEnabled: isEditingMode, fontSize: 15) { t in
                    self.selectedPoso.info = t
                }
                cell.selectionStyle = .none
            case calendarCellRow:
                cell = tableView.dequeueReusableCell(withIdentifier: EditDateCell.identifier, for: indexPath) as! EditDateCell
                (cell as! EditDateCell).configure(date: selectedPoso.date)
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            case repeatCellRow:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath) as! EditRepeatCell
                (cell as! EditRepeatCell).configure(caption: "Повторить", detail: "нет")
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            case notifyCellRow:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath) as! EditRepeatCell
                (cell as! EditRepeatCell).configure(caption: "Напомнить", detail: "нет")
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            case statisticCellRow:
                switch selectedEventType! {
                case .eating:
                    cell = tableView.dequeueReusableCell(withIdentifier: StatisticEatingCell.identifier, for: indexPath) as! StatisticEatingCell
                    (cell as! StatisticEatingCell).configure(with: selectedPoso as! Eating)
                case .drugs:
                    cell = tableView.dequeueReusableCell(withIdentifier: StatisticDrugCell.identifier, for: indexPath) as! StatisticDrugCell
                    //(cell as! StatisticEatingCell).configure(with: selectedPoso as! Eating)
                case .measure:
                    cell = tableView.dequeueReusableCell(withIdentifier: StatisticMeasureCell.identifier, for: indexPath) as! StatisticMeasureCell
                    //(cell as! StatisticEatingCell).configure(with: selectedPoso as! Eating)
                case .train:
                    cell = tableView.dequeueReusableCell(withIdentifier: StatisticTrainCell.identifier, for: indexPath) as! StatisticTrainCell
                    //(cell as! StatisticEatingCell).configure(with: selectedPoso as! Eating)
                }
                cell.selectionStyle = .none
            default:
                cell = UITableViewCell()
            }
        } else if indexPath.section == 1 {
            
            switch selectedEventType! {
            case .eating:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    //cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                    (cell as! AddHeaderCell).captionLabel.text = "Ингредиенты"
                    (cell as! AddHeaderCell).rotateArrow()
                }else if selectedPoso.subEvents.count > 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: AddIngredientCell.identifier, for: indexPath) as! AddIngredientCell
                    (cell as! AddIngredientCell).configure(subEvent: selectedPoso.subEvents[indexPath.row - 1] as! IngredientE)
                    
                    if (!isEditingMode) {
                        (cell as! AddIngredientCell).nameLabelConstraint.constant = (view.frame.width - 33 - 16)
                    }else{
                        (cell as! AddIngredientCell).nameLabelConstraint.constant = (view.frame.width - 33 - 16 - 43 - 52)
                    }
                    cell.setNeedsLayout()
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: EditEmptyCell.identifier, for: indexPath) as! EditEmptyCell
                }
            case .train:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    //cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                    (cell as! AddHeaderCell).captionLabel.text = "Упражнения"
                    (cell as! AddHeaderCell).rotateArrow()
                }else if selectedPoso.subEvents.count > 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: CalendarExerciseCell.identifier, for: indexPath) as! CalendarExerciseCell
                    (cell as! CalendarExerciseCell).configure()
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: EditEmptyCell.identifier, for: indexPath) as! EditEmptyCell
                }
            case .measure:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    //cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewMeasure)))
                    (cell as! AddHeaderCell).captionLabel.text = "Измерения"
                    (cell as! AddHeaderCell).rotateArrow()
                }else if selectedPoso.subEvents.count > 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: AddMeasureCell.identifier, for: indexPath) as! AddMeasureCell
                    (cell as! AddMeasureCell).configure(subEvent: selectedPoso.subEvents[indexPath.row - 1] as! Measure)
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: EditEmptyCell.identifier, for: indexPath) as! EditEmptyCell
                }
            case .drugs:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier, for: indexPath) as! AddHeaderCell
                    //cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNewExercise)))
                    (cell as! AddHeaderCell).captionLabel.text = "Препараты"
                    (cell as! AddHeaderCell).rotateArrow()
                }else if selectedPoso.subEvents.count > 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: AddDrugCell.identifier, for: indexPath) as! AddDrugCell
                    (cell as! AddDrugCell).configure(subEvent: selectedPoso.subEvents[indexPath.row - 1] as! DrugE)
                }else{
                    cell = tableView.dequeueReusableCell(withIdentifier: EditEmptyCell.identifier, for: indexPath) as! EditEmptyCell
                }
            }
            cell.selectionStyle = isEditingMode ? .default : .none
        } else if indexPath.section == 2{
            cell = tableView.dequeueReusableCell(withIdentifier: EditDeleteCell.identifier, for: indexPath) as! EditDeleteCell
        } else {
            cell = UITableViewCell()
            fatalError("no case for cell!!")
        }
        
        //cell.layoutSubviews()
        return cell
    }
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //        if cell.isKind(of: AddIngredientCell.self) {
    //            //(cell as! AddIngredientCell).nameLabel.sizeToFit()
    //        }
    //
    //        cell.setNeedsLayout()
    //        cell.layoutIfNeeded()
    //        cell.layoutSubviews()
    //    }
    //    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }

    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 0{
            return .none
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return .insert
            }else{
                return selectedPoso.subEvents.count == 0 ? .none : .delete
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
            if selectedPoso.subEvents.count == 0 {
                //tableView.insertRows(at: [indexPath], with: .automatic)
                //tableView.deleteRows(at: [indexPath], with: .automatic)
            }else{
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //tableView.insertRows(at: [indexPath], with: .automatic)
            }
            self.tableView.reloadSections([1], with: .none)
            self.tableView.reloadRows(at: [IndexPath(row: self.statisticCellRow, section: 0)], with: .none)
            
            
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
        if indexPath.section == 0 || indexPath.section == 2{
            return false
        } else {
            if indexPath.row == 0 || (indexPath.row == 1 && selectedPoso.subEvents.count == 0){
                return false
            }else{
                return true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        selectedPoso.moveSubEvent(fromIndex: sourceIndexPath.row - 1, toIndex: destinationIndexPath.row - 1)
        
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
    
    @objc func addNewIngredient(){
        performSegue(withIdentifier: "IngredientsListSegue", sender: self)
    }
    
    @objc func addNewExercise(){
        performSegue(withIdentifier: "IngredientsListSegue", sender: self)
    }
    @objc func addNewMeasure(){
        performSegue(withIdentifier: "MeasureChooseSegue", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 2:
                performSegue(withIdentifier: "ShowCalendarSegue", sender: self)
            default:
                break
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                if selectedEventType == .measure {
                    addNewMeasure()
                }else{
                    addNewExercise()
                }
            }else{
                //show alert for editing
            }
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
            vc.selectedPosObjects = selectedPoso.subEvents
            vc.selectedSubEventType = selectedEventType.subEventType
            vc.navigationItem.title = "Выберите"
            vc.navigationItem.rightBarButtonItem = nil
            vc.complitionHandler = { selectedSubEvents in
                self.selectedPoso.addSubEvents(subEvents: selectedSubEvents)
                self.tableView.reloadSections([1], with: .automatic)
                self.tableView.reloadRows(at: [IndexPath(row: self.statisticCellRow, section: 0)], with: .automatic)
            }
        }
        
        if segue.identifier == "MeasureChooseSegue" {
            let vc = segue.destination as! MeasureChooseViewController
            vc.selectedPosObjects = selectedPoso.subEvents
            vc.navigationItem.title = "Выберите"
            vc.complitionHandler = { selectedSubEvents in
                self.selectedPoso.addSubEvents(subEvents: selectedSubEvents)
                self.tableView.reloadSections([1], with: .automatic)
                self.tableView.reloadRows(at: [IndexPath(row: self.statisticCellRow, section: 0)], with: .automatic)
            }
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
        tableView.reloadSections([0,1], with: .none)
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
        selectedPoso.backup()
        tableView.reloadSections([0,1], with: .none)
        setEditingMode(isEdit: false)
        
        
        //dismiss(animated: true, completion: nil)
    }
    
}

extension EventDetailTableViewController: SmartFieldDelegate {
    func updateNumericValueBy(row: Int, text: String) {
        switch row
        {
        case 0:
            //selectedPoso.name = text
            break
        case 1:
            //selectedPoso.info = text
            break
        default:
            print("It is nothing");
        }
    }
    
}
























