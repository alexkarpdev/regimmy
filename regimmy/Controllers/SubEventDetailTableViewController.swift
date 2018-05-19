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

    
    var navc: UINavigationController?
    var selectedSubEventType: SubEventType!
    
    var selectedSubEvent: Object!
    
    var isEditingMode = false
    
    @IBOutlet var leftButtonItem: UIBarButtonItem!
    @IBOutlet var rightButtonItem: UIBarButtonItem!
    
    var selectedMuscleType: MuscleType?
    var selectedPropertyType: PropertyType!
    var selectedProperty: String?
    var selectedRow: IndexPath!
    
    var propertiesList: [String]!
    
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
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: (selectedSubEvent as! RExercise).name)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
            case 1:
//                cell = tableView.dequeueReusableCell(withIdentifier: EditorDescriptionCell.identifier, for: indexPath)
//                (cell as! EditorDescriptionCell).descriptionTextView.text = ""
//                (cell as! EditorDescriptionCell).descriptionTextView.placeholder = "Описание"
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: (selectedSubEvent as! RExercise).info, fontSize: 15)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: PropertyType.exerciseType.rawValue, detail: (selectedSubEvent as! RExercise).type)
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: PropertyType.durationType.rawValue, detail: (selectedSubEvent as! RExercise).durationType)
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: PropertyType.loadUnitType.rawValue, detail: (selectedSubEvent as! RExercise).loadUnit)
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorMuscleChooseCell.identifier, for: indexPath)
                if let mi = MuscleType(rawValue: (selectedSubEvent as! RExercise).muscle) {
                    (cell as! EditorMuscleChooseCell).muscleImage.image = UIImage(named: mi.typeImageName)
                    (cell as! EditorMuscleChooseCell).muscleImage.alpha = 1
                }else{
                    (cell as! EditorMuscleChooseCell).muscleImage.alpha = 0.3
                }
            default:
                cell = UITableViewCell()
            }
        case .ingredient:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: (selectedSubEvent as! RIngredient).name)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: (selectedSubEvent as! RIngredient).info, fontSize: 15)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Белки", value: (selectedSubEvent as! RIngredient).prot, unit: "грамм", color: #colorLiteral(red: 0.1058823529, green: 0.6784313725, blue: 0.9725490196, alpha: 1))
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Жиры", value: (selectedSubEvent as! RIngredient).fat, unit: "грамм", color: #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1))
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Углеводы", value: (selectedSubEvent as! RIngredient).carbo, unit: "грамм", color: #colorLiteral(red: 0.3882352941, green: 0.8549019608, blue: 0.2196078431, alpha: 1))
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Энерг.", value: (selectedSubEvent as! RIngredient).cal, unit: "ккал.", color: #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1))
                (cell as! EditorNutrientCell).valueField.delegate = self
                (cell as! EditorNutrientCell).valueField.tag = indexPath.row
            default:
                cell = UITableViewCell()
            }
        case .drug:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Название", text: (selectedSubEvent as! RDrug).name)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: EditFieldCell.identifier, for: indexPath)
                (cell as! EditFieldCell).configure(placeHolder: "Примечание", text: (selectedSubEvent as! RDrug).info, fontSize: 15)
                (cell as! EditFieldCell).textField.delegate = self
                (cell as! EditFieldCell).textField.tag = indexPath.row
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: EditRepeatCell.identifier, for: indexPath)
                (cell as! EditRepeatCell).configure(caption: "Ед. измерения", detail: (selectedSubEvent as! RDrug).servUnit)
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: EditorNutrientCell.identifier, for: indexPath)
                (cell as! EditorNutrientCell).configure(name: "Размер порции", value: (selectedSubEvent as! RDrug).servSize, unit: (selectedSubEvent as! RDrug).servUnit, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            default:
                cell = UITableViewCell()
            }
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath
        switch selectedSubEventType! {
        case .exercise:
            switch indexPath.row {
            case 2:
                propertiesList = [ExerciseType.force.rawValue, ExerciseType.cardio.rawValue, ExerciseType.stretch.rawValue, ExerciseType
                    .warmup.rawValue]
                selectedPropertyType = .exerciseType
                selectedProperty = (selectedSubEvent as! RExercise).type
                performSegue(withIdentifier: "PropertiesListSegue", sender: self)
            case 3:
                propertiesList = [DurationUnitType.repeats.rawValue, DurationUnitType.time.rawValue, DurationUnitType.laps.rawValue, DurationUnitType.distance.rawValue]
                selectedPropertyType = .durationType
                selectedProperty = (selectedSubEvent as! RExercise).durationType
                performSegue(withIdentifier: "PropertiesListSegue", sender: self)
            case 4:
                propertiesList = [LoadUnitType.mass.rawValue, LoadUnitType.time.rawValue, LoadUnitType.lap.rawValue, LoadUnitType.selfmass.rawValue]
                selectedPropertyType = .loadUnitType
                selectedProperty = (selectedSubEvent as! RExercise).loadUnit
                performSegue(withIdentifier: "PropertiesListSegue", sender: self)
            case 5:
                selectedMuscleType = MuscleType(rawValue: (selectedSubEvent as! RExercise).muscle)
                performSegue(withIdentifier: "MuscleChooseSegue", sender: self)
            default:
                break
            }
        case .ingredient:
            break
        case .drug:
            propertiesList = [DrugUnitType.mass.rawValue, DrugUnitType.capsule.rawValue, DrugUnitType.tablet.rawValue, DrugUnitType.scoop.rawValue, DrugUnitType.volume.rawValue, DrugUnitType.ued.rawValue]
            selectedPropertyType = .drugUnitType
            selectedProperty = (selectedSubEvent as! RDrug).servUnit
            performSegue(withIdentifier: "PropertiesListSegue", sender: self)
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
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openForEditAction() {
        setEditingMode(isEdit: true)
        //performSegue(withIdentifier: "IngredientsEditSegue", sender: self)
    }
    
    @objc func saveAction() {
        RealmDBController.shared.save(object: selectedSubEvent)
        setEditingMode(isEdit: false)
        if navigationController?.viewControllers.first === self {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func performSelectionHandler(property: String) {
        try! RealmDBController.shared.realm.write{
            switch selectedPropertyType! {
            case .exerciseType:
                (selectedSubEvent as! RExercise).type = property
            case .durationType:
                (selectedSubEvent as! RExercise).durationType = property
            case .loadUnitType:
                (selectedSubEvent as! RExercise).loadUnit = property
            case .drugUnitType:
                (selectedSubEvent as! RDrug).servUnit = property
            default:
                break
            }
        }
        tableView.reloadRows(at: [selectedRow], with: .automatic)
        
    }
    
    func performSelectionHendler(selectedMuscle: MuscleType) {
        try! RealmDBController.shared.realm.write{
            (selectedSubEvent as! RExercise).muscle = selectedMuscle.rawValue
        }
        tableView.reloadRows(at: [selectedRow], with: .automatic)
    }
    
    

     @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        setEditingMode(isEdit: false)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") + string
        try! RealmDBController.shared.realm.write{
            switch selectedSubEventType! {
            case .exercise:
                switch textField.tag {
                case 0:
                    (selectedSubEvent as! RExercise).name = text
                case 1:
                    (selectedSubEvent as! RExercise).info = text
                default:
                    break
                }
            case .ingredient:
                switch textField.tag {
                case 0:
                    (selectedSubEvent as! RIngredient).name = text
                case 1:
                    (selectedSubEvent as! RIngredient).info = text
                case 2:
                    (selectedSubEvent as! RIngredient).prot = Double(text)!
                case 3:
                    (selectedSubEvent as! RIngredient).fat = Double(text)!
                case 4:
                    (selectedSubEvent as! RIngredient).carbo = Double(text)!
                case 5:
                    (selectedSubEvent as! RIngredient).cal = Double(text)!
                default:
                    break
                }
            case .drug:
                switch textField.tag {
                case 0:
                    (selectedSubEvent as! RDrug).name = text
                case 1:
                    (selectedSubEvent as! RDrug).info = text
                default:
                    break
                }
            }
        }

        return true
    }
    
}













