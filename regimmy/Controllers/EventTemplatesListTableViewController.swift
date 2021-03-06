//
//  AddTemplateTableViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 29.03.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit

class EventTemplatesListTableViewController: UITableViewController {
    
    var selectedEventType: EventType!
    
    var captions = ["Новую", "Последние", "Избранное"]
    
    var complitionHandler: (()->())!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //navigationController?.navigationBar.topItem?.title = selectedEventType.name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let headerView = (Bundle.main.loadNibNamed(CalendarHeaderCell.identifier, owner: self, options: nil)![0] as? UIView)
//        tableView.tableHeaderView = headerView
        
        tableView.register(UINib(nibName: AddHeaderCell.identifier, bundle: nil), forCellReuseIdentifier: AddHeaderCell.identifier)
        
        tableView.register(UINib(nibName: AddMeasureCell.identifier, bundle: nil), forCellReuseIdentifier: AddMeasureCell.identifier)
        tableView.register(UINib(nibName: AddEatingCell.identifier, bundle: nil), forCellReuseIdentifier: AddEatingCell.identifier)
        tableView.register(UINib(nibName: AddTrainCell.identifier, bundle: nil), forCellReuseIdentifier: AddTrainCell.identifier)
        tableView.register(UINib(nibName: AddDruggingCell.identifier, bundle: nil), forCellReuseIdentifier: AddDruggingCell.identifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44
        
        self.tableView.tableFooterView = UIView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return captions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 0 : 2
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddHeaderCell.identifier) as! AddHeaderCell
        var caption = captions[section]
        
        if section == 0 {
            cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeNewEvent)))
            switch selectedEventType! {
            case .eating:
                caption = "Новый"
            case .train:
                caption = "Новую"
            case .measure:
                caption = "Новые"
            case .drugs:
                caption = "Новый"
            }
        }else{
            cell.rotateArrow()
        }
        
        cell.captionLabel.text = caption
        
        let seporatorView = UIView(frame: CGRect(x: 15, y: cell.frame.size.height - 1, width: self.view.frame.size.width - 15, height: 0.5))
        seporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.contentView.addSubview(seporatorView)
        
        if section == 2 {
            let topSeporatorView = UIView(frame: CGRect(x: 8, y: 0, width: self.view.frame.size.width - 8, height: 0.5))
            topSeporatorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.contentView.addSubview(topSeporatorView)
        }
        
        return cell.contentView
    }
    
    @objc func makeNewEvent(){
        performSegue(withIdentifier: "AddEventSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        switch selectedEventType! {
        case .eating:
            cell = tableView.dequeueReusableCell(withIdentifier: AddEatingCell.identifier, for: indexPath) as! AddEatingCell
        case .train:
            cell = tableView.dequeueReusableCell(withIdentifier: AddTrainCell.identifier, for: indexPath) as! AddTrainCell
        case .measure:
            cell = tableView.dequeueReusableCell(withIdentifier: AddTrainCell.identifier, for: indexPath) as! AddTrainCell
        case .drugs:
            cell = tableView.dequeueReusableCell(withIdentifier: AddDruggingCell.identifier, for: indexPath) as! AddDruggingCell
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

    
    // MARK: - Navigation

    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEventSegue" {
            let vc = (segue.destination as! UINavigationController).viewControllers.first as! EventDetailTableViewController
            
            let newEvent: RootEvent!
            switch selectedEventType! {
            case .eating:
                newEvent = Eating()
            case .train:
                newEvent = Train()
            case .measure:
                newEvent = Measuring()
            case .drugs:
                newEvent = Drugging()
            }
            
            newEvent.type = selectedEventType
            vc.selectedPoso = newEvent
            vc.navigationItem.title = selectedEventType.name
            
            vc.navc = self.navigationController // это нужно для того, чтобы вернуться сразу в дневник
            
            vc.complitionHandler = complitionHandler
        }
    }
    
    func createNewEvent() { // delete!!!
        let selectedEventType: EventType = .train
        
        let newEvent: RootEvent!
        switch selectedEventType {
        case .eating:
            newEvent = Eating()
        case .train:
            newEvent = Train()
        case .measure:
            newEvent = Measuring()
        case .drugs:
            newEvent = Drugging()
        }
        
        newEvent.type = selectedEventType
        let selectedPoso = newEvent
        print("log: tested AddEvent")
    }
    

}
