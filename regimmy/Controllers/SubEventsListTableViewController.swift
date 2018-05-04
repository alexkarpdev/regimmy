//
//  IngredientsListTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 01.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
import RealmSwift

class SubEventsListTableViewController: UITableViewController {
    
    var selectedEventType: EventType!
    var selectedSubEventType: SubEventType!
    
    var isEditorMode = true
    
    var selectedObjects = [Object]()
    var objects = [Object]()
    
    let repeatList = ["Нет", "Каждый день", "Каждую неделю", "Каждые 2 недели", "Каждый месяц", "Каждый год"]
    let notifyList = ["Нет", "В момент события", "За 5 минут", "За 15 минут", "За 30 минут", "За 1 час", "За 2 часа", "За 1 день", "За 2 дня", "За 2 неделю"]

    @IBOutlet var leftButtonItem: UIBarButtonItem!
    @IBOutlet var rightButtonItem: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonItemsForEditor()
        
        if let sel = selectedSubEventType {
            
            //set right button on edit
            
            switch sel {
            case .exercise:
                selectedEventType = .train
                objects = RealmDBController.shared.load() as [RExercise]
            case .ingredient:
                selectedEventType = .eating
                objects = RealmDBController.shared.load() as [RIngredient]
            case .drug:
                selectedEventType = .drugs
                objects = RealmDBController.shared.load() as [RDrug]
            default:
                break
            }
            
        }else{
            
        }
        
        
        tableView.register(UINib(nibName: EditorIngredientCell.identifier, bundle: nil), forCellReuseIdentifier: EditorIngredientCell.identifier)
        tableView.register(UINib(nibName: CalendarMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarMeasureCell.identifier)
        tableView.register(UINib(nibName: CalendarIngredientCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarIngredientCell.identifier)
        tableView.register(UINib(nibName: CalendarExerciseCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarExerciseCell.identifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableHeaderView = UIView()
        
    }
    //func setButtonsFor
    func setButtonItemsForEditor(){
        if navigationController?.viewControllers.first !== self {
            
            //tabBarController?.tabBar.isHidden = tableView.isEditing
            if tableView.isEditing == true {
                hideTabBar()
                rightButtonItem.action = #selector(addAction)
                rightButtonItem.target = self
                rightButtonItem.title = "Добавить"
                navigationItem.leftBarButtonItem = leftButtonItem
            }else{
                showTabBar()
                navigationItem.leftBarButtonItem = nil
                rightButtonItem.action = #selector(openForEditAction)
                rightButtonItem.target = self
                rightButtonItem.title = "Изменить"
            }
        }else{
            navigationItem.leftBarButtonItem?.action = #selector(dismissAction(_:))
            navigationItem.leftBarButtonItem?.target = self
            navigationItem.leftBarButtonItem?.title = "Готово"
            
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
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        //let selectedEventType: EventType = .train
        
        
        switch selectedEventType! {
        case .eating:
            cell = tableView.dequeueReusableCell(withIdentifier: EditorIngredientCell.identifier, for: indexPath) as! EditorIngredientCell
            let object = objects[indexPath.row] as! RIngredient
            (cell as! EditorIngredientCell).configure(name: object.name, prot: object.prot, fat: object.fat, carb: object.carbo, cal: object.cal)
        case .train:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarExerciseCell.identifier, for: indexPath) as! CalendarExerciseCell
        case .measure:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarMeasureCell.identifier, for: indexPath) as! CalendarMeasureCell
        case .drugs:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarMeasureCell.identifier, for: indexPath) as! CalendarMeasureCell
        }
        
        if isEditorMode {
            cell.accessoryType = .disclosureIndicator
        }else{
            //checkMARK
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedEventType! {
        case .eating:
            break
        case .train:
            performSegue(withIdentifier: "SetsListSegue", sender: self)
        case .measure:
            break
        case .drugs:
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddSubEventSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers.first as! EditorSubEventDetailTableViewController
            vc.selectedSubEventType = selectedSubEventType
        }
        
        if segue.identifier == "ShowSubEventDetailSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers.first as! EditorSubEventDetailTableViewController
            vc.selectedSubEventType = selectedSubEventType
        }
    }
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        tableView.setEditing(false, animated: true)
        setButtonItemsForEditor()
        //dismiss(animated: true, completion: nil)
    }
    
    @objc func openForEditAction() {
        tableView.setEditing(true, animated: true)
        setButtonItemsForEditor()
        //performSegue(withIdentifier: "IngredientsEditSegue", sender: self)
    }
    
     @objc func addAction() {
        performSegue(withIdentifier: "AddSubEventSegue", sender: self)
    }
    
    
    
}
