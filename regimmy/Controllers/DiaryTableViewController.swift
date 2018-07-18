//
//  DiaryTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 05.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryTableViewController: UITableViewController {
    
   // var events = [SimpleEvent]()
    
    @IBOutlet var leftButton: UIBarButtonItem! //calendar
    @IBOutlet var rightButton: UIBarButtonItem! //add
    
    @IBOutlet var topDateLabel: UILabel!
    @IBOutlet var todayLabel: UILabel!
    
    //@IBOutlet var calendarButton: UIButton!
    //@IBOutlet var addEventButton: UIButton!
    
    var tapOnTableView: UITapGestureRecognizer!
    
    var isItemsShowen = false
    
    var selectedDate = Date()
    
    //var selectedEvent: RBaseEvent?
    
    var objects = [RBaseEvent]()
    
    var selectedPosObjects = [RootEvent]()
    var posObjects = [RootEvent]()
    var selectedPoso: RootEvent!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tapOnTableView = UITapGestureRecognizer(target: self, action: #selector(showSelectedEvent(sender:)))
        view.addGestureRecognizer(tapOnTableView)
        view.isUserInteractionEnabled = true
        
        setUpItemButtons()
        
       
        let headerView = (Bundle.main.loadNibNamed(CalendarHeaderCell.identifier, owner: self, options: nil)![0] as? CalendarHeaderCell)
        
        topDateLabel = headerView?.topDateLabel
        todayLabel = headerView?.todayLabel
        
        //headerView?.calendarButton.addTarget(self, action: #selector(calendarAction(_:)), for: .touchUpInside)
        //headerView?.addEventButton.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        
        //let seporatorView = UIView(frame: CGRect(x: 0, y: headerView!.frame.size.height - 1, width: self.view.frame.size.width, height: 0.5))
        //seporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //headerView!.addSubview(seporatorView)
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib(nibName: SimpleEventCell.identifier, bundle: nil), forCellReuseIdentifier: SimpleEventCell.identifier)
        tableView.register(UINib(nibName: CalendarEatingHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarEatingHeaderCell.identifier)
        
        tableView.register(UINib(nibName: CalendarMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarMeasureCell.identifier)
        tableView.register(UINib(nibName: CalendarIngredientCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarIngredientCell.identifier)
        tableView.register(UINib(nibName: CalendarExerciseCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarExerciseCell.identifier)
        tableView.register(UINib(nibName: "CalendarDrugCell", bundle: nil), forCellReuseIdentifier: AddDrugCell.identifier)
        tableView.register(UINib(nibName: "CalendarMeasureCell", bundle: nil), forCellReuseIdentifier: AddMeasureCell.identifier)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44
        
        //tableView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //generateEvents()
        
        //loadEvents()
        
        updateDateOn(selectedDate: selectedDate)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.shadowImage = nil
    }
    
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "AddSegue", sender: self)
        debugPrint("addAction")
    }
    
    @IBAction func calendarAction(_ sender: Any) {
        performSegue(withIdentifier: "ShowCalendarSegue", sender: self)
        debugPrint("calendarAction")
    }
    
    func setUpItemButtons(){
        let lButton = UIButton(type: .custom)
        let rButton = UIButton(type: .custom)
        
        lButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        rButton.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        lButton.setImage(UIImage(named:"calendar"), for: .normal)
        rButton.setImage(UIImage(named:"addEvent"), for: .normal)
        
        lButton.addTarget(self, action: #selector(calendarAction(_:)), for: UIControlEvents.touchUpInside)
        rButton.addTarget(self, action: #selector(addAction(_:)), for: UIControlEvents.touchUpInside)
        
        let leftMenuBarItem = UIBarButtonItem(customView: lButton)
        let rightMenuBarItem = UIBarButtonItem(customView: rButton)
        
        let currWidthL = leftMenuBarItem.customView?.widthAnchor.constraint(equalToConstant: 28)
        currWidthL?.isActive = true
        let currHeightL = leftMenuBarItem.customView?.heightAnchor.constraint(equalToConstant: 28)
        currHeightL?.isActive = true
        leftButton = leftMenuBarItem
        
        let currWidthR = rightMenuBarItem.customView?.widthAnchor.constraint(equalToConstant: 28)
        currWidthR?.isActive = true
        let currHeightR = rightMenuBarItem.customView?.heightAnchor.constraint(equalToConstant: 28)
        currHeightR?.isActive = true
        rightButton = rightMenuBarItem
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButton
        navigationController?.navigationBar.topItem?.leftBarButtonItem = leftButton
        //navigationController?.navigationBar.topItem?.title = ""
    }
 
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let ssai = scrollView.safeAreaInsets.top
        let const:CGFloat = 72 //85 - 8
        let border = const - ssai
        let sco = scrollView.contentOffset.y
        let dif = sco - border
        
        if dif > 0 && !isItemsShowen {
            isItemsShowen = true
            //navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButton
            //navigationController?.navigationBar.topItem?.leftBarButtonItem = leftButton
            navigationController?.navigationBar.topItem?.title = todayLabel.text
        }else if dif < 0 && isItemsShowen {
            isItemsShowen = false
            //navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
            //navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
            navigationController?.navigationBar.topItem?.title = "Дневник"
        }
        
    }
    func loadEvents() {
        posObjects.removeAll()
        
        posObjects.append(contentsOf: Array(RealmDBController.shared.loadEventsFor(date: selectedDate) as [REating]).map(){Eating.init(from: ($0))})
        posObjects.append(contentsOf: Array(RealmDBController.shared.loadEventsFor(date: selectedDate) as [RTrain]).map(){Train.init(from: ($0))})
        posObjects.append(contentsOf: Array(RealmDBController.shared.loadEventsFor(date: selectedDate) as [RMeasuring]).map(){Measuring.init(from: ($0))})
        posObjects.append(contentsOf: Array(RealmDBController.shared.loadEventsFor(date: selectedDate) as [RDrugging]).map(){Drugging.init(from: ($0))})
        
        posObjects.sort(){$0.date < $1.date}
        //objects.append(RealmDBController.shared.loadEventsFor(date: selectedDate) as [REating])
        //posObjects = objects.map(){BaseEvent.init(from: ($0))}
        
        tableView.reloadData()
    }
    
    func generateEvents(){
        
        let names = ["Завтрак 1", "Тренировка груди", "Замеры вечер", "Обед углеводы", "Приём препаратов утро", "Ужин белки"]
        let types: [EventType] = [.eating, .train, .measure, .eating, .drugs, .eating]
        
        for i in 0..<names.count {
            let event = SimpleEvent(date: selectedDate, name: names[i], type: types[i])
           // events.append(event)
        }
        
        
    }
    
    func updateDateOn(selectedDate: Date){
        self.selectedDate = selectedDate
        //generateEvents()
        //topDateLabel.text = selectedDate.description(with: Locale(identifier: "ru-RU"))
        prepareDate()
        loadEvents()
    }
    
    func prepareDate(){
        let calendar = Calendar.current
        
        let df = DateFormatter()
        df.dateFormat = "EEEE,dd MMMM"
        df.locale = Locale(identifier: "ru-RU")
        
        var top = ""
        var today = ""
        
        /*
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let day = calendar.component(.day, from: selectedDate)
        let weekday = calendar.component(.weekday, from: selectedDate)
        */
        
        var comps = df.string(from: selectedDate).split(separator: ",")
        
        top = String(comps[0]).capitalizingFirstLetter() + ", " + comps[1]
        
        if calendar.isDateInYesterday(selectedDate) {
            today = "Вчера"
        }else if calendar.isDateInToday(selectedDate) {
            today = "Сегодня"
        }else if calendar.isDateInTomorrow(selectedDate) {
            today = "Завтра"
        }else {
            df.dateFormat = "dd MMMM"
            today = df.string(from: selectedDate)
            
            df.dateFormat = "EEEE, yyyy"
            top = df.string(from: selectedDate)
        }
        
        topDateLabel.text = top.uppercased()
        todayLabel.text = today
        
        if isItemsShowen {
            navigationController?.navigationBar.topItem?.title = todayLabel.text
        }
        
        
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return posObjects.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if posObjects[section].type == .eating {
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarEatingHeaderCell.identifier) as! CalendarEatingHeaderCell
            cell.configure(with: posObjects[section] as! Eating)
            
            let bottomSeporatorView = UIView(frame: CGRect(x: 64, y: cell.frame.size.height - 1, width: self.view.frame.size.width - 64, height: 0.5))
            bottomSeporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.contentView.addSubview(bottomSeporatorView)
            
            let topSeporatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5))
            topSeporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.contentView.addSubview(topSeporatorView)
            
//            cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSelectedEvent(sender:))))
//            cell.contentView.tag = section
            
            return cell.contentView
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleEventCell.identifier) as! SimpleEventCell
        cell.configure(with: posObjects[section])
        
        let bottomSeporatorView = UIView(frame: CGRect(x: 64, y: cell.frame.size.height - 1, width: self.view.frame.size.width - 64, height: 0.5))
        bottomSeporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.contentView.addSubview(bottomSeporatorView)
        
        let topSeporatorView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5))
        topSeporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.contentView.addSubview(topSeporatorView)
        
//        cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSelectedEvent(sender:))))
//        cell.contentView.tag = section
        
        return cell.contentView
    }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posObjects[section].subEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        switch posObjects[indexPath.section].type! {
        case .eating:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarIngredientCell.identifier, for: indexPath) as! CalendarIngredientCell
            (cell as! CalendarIngredientCell).configure(subEvent: posObjects[indexPath.section].subEvents[indexPath.row] as! IngredientE)
        case .train:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarExerciseCell.identifier, for: indexPath) as! CalendarExerciseCell
            (cell as! CalendarExerciseCell).configure(exercise: posObjects[indexPath.section].subEvents[indexPath.row] as! ExerciseE)
        case .measure:
            cell = tableView.dequeueReusableCell(withIdentifier: AddMeasureCell.identifier, for: indexPath) as! AddMeasureCell
            (cell as! AddMeasureCell).configure(subEvent: posObjects[indexPath.section].subEvents[indexPath.row] as! Measure)
        case .drugs:
            cell = tableView.dequeueReusableCell(withIdentifier: AddDrugCell.identifier, for: indexPath) as! AddDrugCell
            (cell as! AddDrugCell).configure(subEvent: posObjects[indexPath.section].subEvents[indexPath.row] as! DrugE)
        default:
            break
        }
        //cell.configure(with: events[indexPath.row])

        cell.separatorInset.left = 64
        cell.layoutIfNeeded()
        
        return cell
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
    
    @objc func showSelectedEvent(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            guard let tableView = self.tableView else {
                return
            }
            if let view = sender.view {
                let tapLocation = sender.location(in: tableView)
                if let tapIndexPath = tableView.indexPathForRow(at: tapLocation) {
                    if (tableView.cellForRow(at: tapIndexPath) as? UITableViewCell) != nil {
                        // do something with the row
                        selectedPoso = posObjects[tapIndexPath.section]
                        performSegue(withIdentifier: "ShowEventSegue", sender: self)
                        print("tapped on row at index: \(tapIndexPath.row)")
                    }
                }  else {
                    for i in 0..<tableView.numberOfSections {
                        let sectionHeaderArea = tableView.rectForHeader(inSection: i)
                        if sectionHeaderArea.contains(tapLocation) {
                            // do something with the section
                            selectedPoso = posObjects[i]
                            performSegue(withIdentifier: "ShowEventSegue", sender: self)
                            print("tapped on section at index: \(i)")
                        }
                    }
                }
            }
        }
    }

//    @objc func showSelectedEvent(sender: UITapGestureRecognizer) {
//
//        let tapLocation = sender.location(in: tableView)
//        if let indexPath: IndexPath = tableView.indexPathForRow(at: tapLocation){
//
//            print("tag = \(indexPath.section)")
//            //selectedEvent.type = events[indexPath.section].type.rawValue
//            selectedPoso = posObjects[indexPath.section]
//            performSegue(withIdentifier: "ShowEventSegue", sender: self)
//        }else{
//            selectedPoso = posObjects[Int(sender.name!)!]
//            performSegue(withIdentifier: "ShowEventSegue", sender: self)
//        }
//    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ShowCalendarSegue" {
            hideTabBar()
            (segue.destination as! CalendarViewController).selectedDate = selectedDate
            (segue.destination as! CalendarViewController).isPickerHidden = true
            (segue.destination as! CalendarViewController).completion = { [unowned self](selectedDate: Date) in
                
                self.showTabBar()
                self.updateDateOn(selectedDate: selectedDate)
                print(selectedDate)
            }
        }
        if segue.identifier == "ShowEventSegue" {
            let vc = segue.destination as! EventDetailTableViewController
            //vc.selectedEventType = EventType(rawValue: (selectedEvent.type))!
            vc.selectedPoso = selectedPoso
            vc.complitionHandler = { [unowned self] in
                self.updateDateOn(selectedDate: self.selectedDate)
            }
        }
        
        if segue.identifier == "AddSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers.first as! EventTypesListTableViewController
            vc.complitionHandler = { [unowned self] in
                self.updateDateOn(selectedDate: self.selectedDate)
            }
        }
    }
    

}


