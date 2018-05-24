//
//  EditorEditSubeventTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 13.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
import RealmSwift

class SubEventDetailTableViewController: UITableViewController {
    
    let nameCellRow = 0
    let infoCellRow = 1
    
    let typeCellRow = 2
    let durationCellRow = 3
    let loadUnitCellRow = 4
    let muscleCellRow = 5
    
    let servUnitRow = 2
    let servSizeCellRow = 3
    
    let protCellRow = 2
    let fatCellRow = 3
    let carbCellRow = 4
    let 

    
    var navc: UINavigationController?
    var selectedSubEventType: SubEventType!
    var selectedSubEvent: RBaseSubEvent!
    
    var selectedPoso: RootEvent!
    
    var isEditingMode = false
    var showInfoCell = true
    
    @IBOutlet var leftButtonItem: UIBarButtonItem!
    @IBOutlet var rightButtonItem: UIBarButtonItem!
    
    var selectedMuscleType: MuscleType?
    var selectedPropertyType: PropertyType!
    var selectedProperty: String?
    var selectedRow: IndexPath!
    
    var propertiesList: [String]!
    
    var complitionHandler: (()->())!
    
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
        setButtonItemsForEditor()
        
        isEdit ? hideTabBar() : showTabBar()
        
        tableView.reloadSections([0], with: .automatic)
    }
    
    func setButtonItemsForEditor(){
        //tabBarController?.tabBar.isHidden = tableView.isEditing
        if isEditingMode == true {
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        showInfoCell = !selectedPoso.info.isEmpty || isEditingMode
        
        var count = showInfoCell ? 0 : -1
        
        switch selectedSubEventType! {
        case .exercise:
            count += 6
        case .ingredient:
            count += 6
        case .drug:
            count += 4
        }
        
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!

        switch selectedSubEventType! {
        case .exercise:
            
            let exercisePoso = selectedPoso as! Exercise
            
            switch true {
            case indexPath.row == 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: exercisePoso.name)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
                cell.selectionStyle = .none
            case (indexPath.row == 1 && showInfoCell):
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: exercisePoso.info, fontSize: 15)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
                cell.selectionStyle = .none
            case (indexPath.row == 2 && showInfoCell) || (indexPath.row == 1 && !showInfoCell):
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: PropertyType.exerciseType.rawValue, detail: exercisePoso.type.rawValue)
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: PropertyType.durationType.rawValue, detail: exercisePoso.durationType.rawValue)
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: PropertyType.loadUnitType.rawValue, detail: exercisePoso.loadUnit.rawValue)
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorMuscleChooseCell.identifier, for: indexPath)
                if let mi = exercisePoso.muscle {
                    (cell as! EditorMuscleChooseCell).muscleImage.image = UIImage(named: mi.typeImageName)
                    (cell as! EditorMuscleChooseCell).muscleImage.alpha = 1
                }else{
                    (cell as! EditorMuscleChooseCell).muscleImage.alpha = 0.3
                }
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            default:
                cell = UITableViewCell()
            }
        case .ingredient:
            
            let ingredientPoso = selectedPoso as! Ingredient
            
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: ingredientPoso.name)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: ingredientPoso.info, fontSize: 15)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Белки", value: ingredientPoso.prot, unit: "грамм", color: #colorLiteral(red: 0.1058823529, green: 0.6784313725, blue: 0.9725490196, alpha: 1), mode: isEditingMode)
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
                (cell as! EditorNutrientCell).valueField.isEnabled = isEditingMode
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Жиры", value: ingredientPoso.fat, unit: "грамм", color: #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1), mode: isEditingMode)
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
                (cell as! EditorNutrientCell).valueField.isEnabled = isEditingMode
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Углеводы", value: ingredientPoso.carbo, unit: "грамм", color: #colorLiteral(red: 0.3882352941, green: 0.8549019608, blue: 0.2196078431, alpha: 1), mode: isEditingMode)
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
                (cell as! EditorNutrientCell).valueField.isEnabled = isEditingMode
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Энерг.", value: ingredientPoso.cal, unit: "ккал.", color: #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1), mode: isEditingMode)
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
                (cell as! EditorNutrientCell).valueField.isEnabled = isEditingMode
            default:
                cell = UITableViewCell()
            }
            cell.selectionStyle = .none
        case .drug:
            
            let drugPoso = selectedPoso as! Drug
            
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: drugPoso.name)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
                cell.selectionStyle = .none
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: drugPoso.info, fontSize: 15)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
                (cell as! EditFieldCell).textField.isEnabled = isEditingMode
                cell.selectionStyle = .none
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: "Ед. измерения", detail: drugPoso.servUnit.rawValue)
                cell.selectionStyle = isEditingMode ? .default : .none
                cell.accessoryType = isEditingMode ? .disclosureIndicator : .none
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Размер порции", value: drugPoso.servSize, unit: drugPoso.servUnit.rawValue, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), mode: isEditingMode)
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
                (cell as! EditorNutrientCell).valueField.isEnabled = isEditingMode
                cell.selectionStyle = .none
            default:
                cell = UITableViewCell()
            }
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditingMode {
            selectedRow = indexPath
            switch selectedSubEventType! {
            case .exercise:
                switch indexPath.row {
                case 2:
                    propertiesList = [ExerciseType.force.rawValue, ExerciseType.cardio.rawValue, ExerciseType.stretch.rawValue, ExerciseType
                        .warmup.rawValue]
                    selectedPropertyType = .exerciseType
                    selectedProperty = (selectedPoso as! Exercise).type.rawValue
                    performSegue(withIdentifier: "PropertiesListSegue", sender: self)
                case 3:
                    propertiesList = [DurationType.repeats.rawValue, DurationType.time.rawValue, DurationType.laps.rawValue, DurationType.distance.rawValue]
                    selectedPropertyType = .durationType
                    selectedProperty = (selectedPoso as! Exercise).durationType.rawValue
                    performSegue(withIdentifier: "PropertiesListSegue", sender: self)
                case 4:
                    propertiesList = [LoadUnitType.mass.rawValue, LoadUnitType.time.rawValue, LoadUnitType.lap.rawValue, LoadUnitType.selfmass.rawValue]
                    selectedPropertyType = .loadUnitType
                    selectedProperty = (selectedPoso as! Exercise).loadUnit.rawValue
                    performSegue(withIdentifier: "PropertiesListSegue", sender: self)
                case 5:
                    selectedMuscleType = (selectedPoso as! Exercise).muscle
                    performSegue(withIdentifier: "MuscleChooseSegue", sender: self)
                default:
                    break
                }
            case .ingredient:
                break
            case .drug:
                propertiesList = [DrugUnitType.mass.rawValue, DrugUnitType.capsule.rawValue, DrugUnitType.tablet.rawValue, DrugUnitType.scoop.rawValue, DrugUnitType.volume.rawValue, DrugUnitType.ued.rawValue]
                selectedPropertyType = .drugUnitType
                selectedProperty = (selectedPoso as! Drug).servUnit.rawValue
                performSegue(withIdentifier: "PropertiesListSegue", sender: self)
            }
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
    @IBAction func dismissAction(_ sender: Any) { // cancel from adding
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openForEditAction() {
        setEditingMode(isEdit: true)
        //performSegue(withIdentifier: "IngredientsEditSegue", sender: self)
    }
    
    @objc func saveAction() {
        selectedPoso.saveToDB()
        setEditingMode(isEdit: false)
        if navigationController?.viewControllers.first === self {
            dismiss(animated: true, completion: complitionHandler)
        }else{
            complitionHandler()
        }
    }
    
    
    func performSelectionHandler(property: String) {
            switch selectedPropertyType! {
            case .exerciseType:
                (selectedPoso as! Exercise).type = ExerciseType(rawValue: property)!
            case .durationType:
                (selectedPoso as! Exercise).durationType = DurationType(rawValue: property)!
            case .loadUnitType:
                (selectedPoso as! Exercise).loadUnit = LoadUnitType(rawValue: property)!
            case .drugUnitType:
                (selectedPoso as! Drug).servUnit = DrugUnitType(rawValue: property)!
                tableView.reloadRows(at: [IndexPath(row: selectedRow.row + 1, section: 0)], with: .automatic)
            default:
                break
            }
        tableView.reloadRows(at: [selectedRow], with: .automatic)
        
    }
    
    func performSelectionHendler(selectedMuscle: MuscleType) {
        try! RealmDBController.shared.realm.write{
            (selectedPoso as! Exercise).muscle = selectedMuscle
        }
        tableView.reloadRows(at: [selectedRow], with: .automatic)
    }
    
    

     @IBAction func cancelAction(_ sender: UIBarButtonItem) { // cancel from editing
        setEditingMode(isEdit: false)
        //perform backup
        selectedPoso.backup()
        tableView.reloadSections([0], with: .automatic)
     }
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PropertiesListSegue" {
            let vc = segue.destination as! PropertiesListTableViewController
            
            vc.navigationItem.title = selectedPropertyType.rawValue
            vc.selectedProperty = selectedProperty
            
            vc.propertiesList = propertiesList
            
            vc.selectionHendler = {[weak self] selectedProperty in
                self?.performSelectionHandler(property: selectedProperty)
                print(selectedProperty)
            }
        }
        
        if segue.identifier == "MuscleChooseSegue" {
            let vc = segue.destination as! MuscleChooseViewController
            
            vc.selectedMuscleType = selectedMuscleType
            
            vc.selectionHendler = {[weak self] selectedMuscle in
                self?.performSelectionHendler(selectedMuscle: selectedMuscle)
                print(selectedMuscle.rawValue)
            }
        }
    }
    

}

extension SubEventDetailTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = ""
        if let t = textField.text,
            let textRange = Range(range, in: t) {
            let updatedText = t.replacingCharacters(in: textRange, with: string)
            text = updatedText
            
            try! RealmDBController.shared.realm.write{
                switch selectedSubEventType! {
                case .exercise:
                    
                    let exercisePoso = selectedPoso as! Exercise
                    
                    switch textField.tag {
                    case 0:
                        exercisePoso.name = text
                    case 1:
                        exercisePoso.info = text
                    default:
                        break
                    }
                case .ingredient:
                    
                    let ingredientPoso = selectedPoso as! Ingredient
                    
                    switch textField.tag {
                    case 0:
                        ingredientPoso.name = text
                    case 1:
                        ingredientPoso.info = text
                    case 2:
                        ingredientPoso.prot = Double(text)!
                    case 3:
                        ingredientPoso.fat = Double(text)!
                    case 4:
                        ingredientPoso.carbo = Double(text)!
                    case 5:
                        ingredientPoso.cal = Double(text)!
                    default:
                        break
                    }
                case .drug:
                    
                    let drugPoso = selectedPoso as! Drug
                    
                    switch textField.tag {
                    case 0:
                        drugPoso.name = text
                    case 1:
                        drugPoso.info = text
                    case 3:
                        drugPoso.servSize = Double(text)!
                    default:
                        break
                    }
                }
            }
        }
        
        return true
    }
    
}













