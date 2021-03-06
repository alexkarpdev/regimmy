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
    //var selectedSubEvent: RBaseSubEvent!
    
    var selectedIndexPath: IndexPath!
    
    var isEditorMode = true
    
    //var selectedObjects = [RBaseSubEvent]()
    //var objects = [RBaseSubEvent]()
    
    var filteredPosObjects = [RootEvent]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedPosObjects = [RootEvent]() // будущие евенты
    var posObjects = [RootEvent]()
    var selectedPosoSubevent: RootEvent! // это для subevent only
    var selectedPosoEvent: RootEvent!
    
    // var results: Results<Object>! // чё-та не понимаю как сделать дженерик
    
    let repeatList = ["Нет", "Каждый день", "Каждую неделю", "Каждые 2 недели", "Каждый месяц", "Каждый год"]
    let notifyList = ["Нет", "В момент события", "За 5 минут", "За 15 минут", "За 30 минут", "За 1 час", "За 2 часа", "За 1 день", "За 2 дня", "За 2 неделю"]
    
    var notificationToken: NotificationToken?
    
    @IBOutlet var leftButtonItem: UIBarButtonItem!
    @IBOutlet var rightButtonItem: UIBarButtonItem!
    
    var complitionHandler: (([RootEvent]) -> ())! //
    var complitionHandlerForSets: (()->())!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEditorMode = navigationController?.viewControllers.first === self ? false : true
        setButtonItemsForEditor()
        
        reloadObjects(.initial)
        
        tableView.register(UINib(nibName: EditorIngredientCell.identifier, bundle: nil), forCellReuseIdentifier: EditorIngredientCell.identifier)
        tableView.register(UINib(nibName: EditorExerciseCell.identifier, bundle: nil), forCellReuseIdentifier: EditorExerciseCell.identifier)
        tableView.register(UINib(nibName: EditorDrugCell.identifier, bundle: nil), forCellReuseIdentifier: EditorDrugCell.identifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.tableHeaderView = UIView()
        
        let ar: [RootEvent] = [RootEvent]()
        ar.index(of: Ingredient())
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        reloadObjects(.insert)
    //    }
    
    func loadFromDB() {
        switch selectedSubEventType! {
        case .exercise:
            selectedEventType = .train
            posObjects = (RealmDBController.shared.load() as [RExercise]).map(){Exercise.init(from: ($0))}
        case .ingredient:
            selectedEventType = .eating
            posObjects = (RealmDBController.shared.load() as [RIngredient]).map(){Ingredient.init(from: ($0))}
        case .drug:
            selectedEventType = .drugs
            posObjects = (RealmDBController.shared.load() as [RDrug]).map(){Drug.init(from: ($0))}
        }
    }
    
    func reloadObjects(_ reloadType: ReloadDataType) {
        
        
        //tableView.reloadData()
        //return
        
        switch reloadType{
        case .delete:
            selectedPosoSubevent.removeFromDB()
            loadFromDB()
            if isFiltering() {
                updateSearchResults(for: searchController)
            }
            
        case .initial:
            loadFromDB()
            tableView.reloadData()
            
        case .insert, .modify:
            loadFromDB()
            if isFiltering() {
                updateSearchResults(for: searchController)
            }
            var index: Int? = nil
            index = getIndexOf(of: selectedPosoSubevent)
            /*
            switch selectedSubEventType! {
            case .exercise:
                index = (posObjects as! [Ingredient]).index(of: selectedPosoSubevent as! Ingredient)
            //index = RealmDBController.shared.index(of: selectedSubEvent as! RExercise)
            case .ingredient:
                index = (posObjects as! [Ingredient]).index(of: selectedPosoSubevent as! Ingredient)
            //index = RealmDBController.shared.index(of: selectedSubEvent as! RIngredient)
            case .drug:
                index = (posObjects as! [Ingredient]).index(of: selectedPosoSubevent as! Ingredient)
                //index = RealmDBController.shared.index(of: selectedSubEvent as! RDrug)
            }
            */
            if let index = index{
                
                if reloadType == .insert{
                    tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }else{
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
                
                tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                
 //               let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))!
 //x               let oldColor = cell.contentView.backgroundColor
//                cell.contentView.backgroundColor = selectedEventType.sectionColor.withAlphaComponent(0.1)
//                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
//                    cell.contentView.backgroundColor = self.selectedEventType.sectionColor.withAlphaComponent(0.8)
//                    }, completion: { (true) in
//                        UIView.animate(withDuration: 0.3) {
//                            cell.contentView.backgroundColor = oldColor
//                        }
//                        })
            }
            
        default:
            break
        }
        
    }
    
    //func setButtonsFor
    func setButtonItemsForEditor(){
        if isEditorMode {
            
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
            
            rightButtonItem.action = #selector(dismissAction(_:))
            rightButtonItem.target = self
            rightButtonItem.title = "Готово"
            navigationItem.rightBarButtonItem = rightButtonItem
            
            leftButtonItem.action = nil
            leftButtonItem.target = nil
            leftButtonItem.title = "Готово2"
            navigationItem.leftBarButtonItem = nil
            
            //navigationItem.leftBarButtonItem?.action = #selector(dismissAction(_:))
            //navigationItem.leftBarButtonItem?.target = self
            //navigationItem.leftBarButtonItem?.title = "Готово"
            
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
        return isFiltering() ? filteredPosObjects.count : posObjects.count
    }
    
    func returnPosObject(row: Int) -> RootEvent {
        return isFiltering() ? filteredPosObjects[row] : posObjects[row]
    }
    func getIndexOf(of object: RootEvent) -> Int? {
        return isFiltering() ? filteredPosObjects.index(of: object) : posObjects.index(of: object)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        //let selectedEventType: EventType = .train
        
        
        switch selectedEventType! {
        case .eating:
            cell = tableView.dequeueReusableCell(withIdentifier: EditorIngredientCell.identifier, for: indexPath) as! EditorIngredientCell
            let posObject = returnPosObject(row: indexPath.row) as! Ingredient
            var mass: Double? = nil
            if isEditorMode {
                cell.accessoryType = .disclosureIndicator
            }else{
                if selectedPosObjects.contains(posObject) {
                    mass = (selectedPosObjects[selectedPosObjects.index(of: posObject)!] as! IngredientE).mass
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            (cell as! EditorIngredientCell).configure(posObject: posObject, mass: mass)
            
        case .train:
            cell = tableView.dequeueReusableCell(withIdentifier: EditorExerciseCell.identifier, for: indexPath) as! EditorExerciseCell
            let posObject = returnPosObject(row: indexPath.row) as! Exercise
            (cell as! EditorExerciseCell).configure(posObject: posObject)
        case .drugs:
            cell = tableView.dequeueReusableCell(withIdentifier: EditorDrugCell.identifier, for: indexPath) as! EditorDrugCell
            let posObject = returnPosObject(row: indexPath.row) as! Drug
            var servs: Double? = nil
            if isEditorMode {
                cell.accessoryType = .disclosureIndicator
            }else{
                if selectedPosObjects.contains(posObject) {
                    servs = (selectedPosObjects[selectedPosObjects.index(of: posObject)!] as! DrugE).servs
                    cell.accessoryType = .checkmark
                }else{
                    cell.accessoryType = .none
                }
            }
            (cell as! EditorDrugCell).configure(posObject: posObject, servs: servs)
            
        default :
            cell = UITableViewCell()
        }
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        selectedIndexPath = indexPath
        
        if isEditorMode {
            //selectedSubEvent = objects[indexPath.row]
            selectedPosoSubevent = returnPosObject(row: indexPath.row)
            performSegue(withIdentifier: "ShowSubEventDetailSegue", sender: self)
        }else{
            if selectedEventType == .train {
                
                selectedPosoSubevent = returnPosObject(row: indexPath.row)
                performSegue(withIdentifier: "SetsListSegue", sender: self)
                
            } else {
                
                if selectedPosObjects.contains(posObjects[indexPath.row]) {
                    
                    selectedPosObjects.remove(at: selectedPosObjects.index(of: posObjects[indexPath.row])!)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                } else {
                    switch selectedEventType! {
                    case .eating:
                        callSmartAlert(caption: "Сколько в граммах?", row: indexPath.row){mass in
                            self.selectedPosObjects.append((self.posObjects[indexPath.row] as! Ingredient).convertToIngredientE(mass: mass))
                        }
                    case .drugs:
                        callSmartAlert(caption: "Сколько порций?", row: indexPath.row){servs in
                            self.selectedPosObjects.append((self.posObjects[indexPath.row] as! Drug).convertToDrugE(servs: servs))
                        }
                    case .measure: // never be used because measure perform at measureViewController
                        break
                    case .train: // never be used because see top ^^^^
                        break
                    }
                    
                }
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
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedPosoSubevent = returnPosObject(row: indexPath.row)
            reloadObjects(.delete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddSubEventSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers.first as! SubEventDetailTableViewController
            vc.selectedSubEventType = selectedSubEventType
            
           // let newSubEvent: RBaseSubEvent! // delete
            
            let newPosoSubevent: RootEvent!
            
            switch selectedSubEventType! {
            case .ingredient:
                newPosoSubevent = Ingredient()
            case .exercise:
                newPosoSubevent = Exercise()
            case .drug:
                newPosoSubevent = Drug()
            }
            
            selectedPosoSubevent = newPosoSubevent
            vc.selectedPoso = selectedPosoSubevent
            
            vc.complitionHandler = ({[unowned self] in
                self.reloadObjects(.insert)
            })
        }
        
        if segue.identifier == "ShowSubEventDetailSegue" {
            let vc = segue.destination as! SubEventDetailTableViewController
            vc.selectedSubEventType = selectedSubEventType
            
            vc.selectedPoso = selectedPosoSubevent
            
            vc.complitionHandler = ({[unowned self] in
                self.reloadObjects(.modify)
            })
        }
        
        if segue.identifier == "SetsListSegue" {
            print("perform segue: \(segue.identifier)")
            
            let vc = (segue.destination as! UINavigationController).topViewController as! SetsListTableViewController
            vc.selectedExercise = (selectedPosoEvent as! Train).createNewExerciseEvent(from: (selectedPosoSubevent as! Exercise))
            
            vc.complitionHandler = { [unowned self] exercise in
                self.selectedPosObjects.append(exercise)
            }
            
        }
    }
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true){ [unowned self] in
            self.complitionHandler(self.selectedPosObjects)
        }
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
    
    func callSmartAlert(caption: String, row: Int, updateAction: @escaping (Double)->()){
        let ac = SmartAlertController(title: caption, message: "\(posObjects[row].name)", preferredStyle: .alert)
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
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            // do something interesting with "answer" here
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    
    // MARK: - Search helping methods
    
    func filterContentForSearchText(_ searchText: String) {
        filteredPosObjects = posObjects.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension SubEventsListTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SubEventsListTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
}















