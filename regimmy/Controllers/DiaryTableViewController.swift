//
//  DiaryTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 05.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class DiaryTableViewController: UITableViewController {
    
    var events = [RootEvent]()
    
    @IBOutlet var leftButton: UIBarButtonItem! //calendar
    @IBOutlet var rightButton: UIBarButtonItem! //add
    var isItemsShowen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.shadowImage = UIImage()
        
        
        setUpItemButtons()
        
       
        let headerView = (Bundle.main.loadNibNamed(CalendarHeaderCell.identifier, owner: self, options: nil)![0] as? UIView)
        let seporatorView = UIView(frame: CGRect(x: 0, y: headerView!.frame.size.height - 1, width: self.view.frame.size.width, height: 0.5))
        seporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headerView!.addSubview(seporatorView)
        tableView.tableHeaderView = headerView
        
        tableView.register(UINib(nibName: SimpleEventCell.identifier, bundle: nil), forCellReuseIdentifier: SimpleEventCell.identifier)
        tableView.register(UINib(nibName: CalendarEatingHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarEatingHeaderCell.identifier)
        
        tableView.register(UINib(nibName: CalendarMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarMeasureCell.identifier)
        tableView.register(UINib(nibName: CalendarIngredientCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarIngredientCell.identifier)
        tableView.register(UINib(nibName: CalendarExerciseCell.identifier, bundle: nil), forCellReuseIdentifier: CalendarExerciseCell.identifier)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        generateEvents()
    }
    
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "AddSegue", sender: self)
        debugPrint("addAction")
    }
    
    @IBAction func calendarAction(_ sender: Any) {
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
    }
 
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let ssai = scrollView.safeAreaInsets.top
        let const:CGFloat = 72 //85 - 8
        let border = const - ssai
        let sco = scrollView.contentOffset.y
        let dif = sco - border
        
        if dif > 0 && !isItemsShowen {
            isItemsShowen = true
            navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButton
            navigationController?.navigationBar.topItem?.leftBarButtonItem = leftButton
            navigationController?.navigationBar.topItem?.title = RootEvent(date: Date(), name: "", type: .drugs).dateString
        }else if dif < 0 && isItemsShowen {
            isItemsShowen = false
            navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
            navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
            navigationController?.navigationBar.topItem?.title = "Дневник"
        }
        
    }
    
    func generateEvents(){
        
        let names = ["Завтрак 1", "Тренировка груди", "Замеры рук, ног", "Обед углеводы", "Протеин", "Ужин белки"]
        let types: [EventType] = [.eating, .train, .measure, .eating, .drugs, .eating]
        
        for i in 0..<names.count {
            let event = RootEvent(date: Date(), name: names[i], type: types[i])
            events.append(event)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if events[section].type == .eating {
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarEatingHeaderCell.identifier) as! CalendarEatingHeaderCell
            cell.configure(with: events[section])
            let seporatorView = UIView(frame: CGRect(x: 15, y: cell.frame.size.height - 1, width: self.view.frame.size.width - 15, height: 0.5))
            seporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.contentView.addSubview(seporatorView)
            return cell.contentView
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SimpleEventCell.identifier) as! SimpleEventCell
        cell.configure(with: events[section])
        
        let seporatorView = UIView(frame: CGRect(x: 15, y: cell.frame.size.height - 1, width: self.view.frame.size.width - 15, height: 0.5))
        seporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.contentView.addSubview(seporatorView)
        
        return cell.contentView
    }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        switch events[indexPath.section].type {
        case .eating:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarIngredientCell.identifier, for: indexPath) as! CalendarIngredientCell
        case .train:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarExerciseCell.identifier, for: indexPath) as! CalendarExerciseCell
            (cell as! CalendarExerciseCell).configure()
        case .measure:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarMeasureCell.identifier, for: indexPath) as! CalendarMeasureCell
        case .drugs:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarMeasureCell.identifier, for: indexPath) as! CalendarMeasureCell
        default:
            break
        }
        //cell.configure(with: events[indexPath.row])

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
