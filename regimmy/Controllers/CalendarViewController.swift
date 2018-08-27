//
//  CalendarViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 23.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
//import FSCalendar


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timePicker: UIDatePicker!
    var isPickerHidden = false
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    var selectedDate: Date?
    var oldSelectedDate: Date?
    
    var completion: ((Date)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        timePicker.isHidden = isPickerHidden
        timePicker.timeZone = TimeZone.current
        calendarView.delegate = self
        calendarView.dataSource = self
        
        
        if let sd = selectedDate {
            calendarView.select(sd)
        }
        
        self.view.layoutSubviews()
        
        visualEffectView.alpha = 0
        stackViewConstraint.constant = self.view.frame.height/2 + stackView.frame.height/2
        
//        print("qq 1: \(stackViewConstraint.constant)")
//        print("qq 2: \(self.view.frame.height)")
//        print("qq 3: \(stackView.frame.height)")
        
        // Do any additional setup after loading the view.
        
        calendarView.register(CastomFSCCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        oldSelectedDate = selectedDate
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: ({
            self.visualEffectView.alpha = 1
            }), completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: ({
            self.stackViewConstraint.constant = 10
            self.view.layoutSubviews()
        }), completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        guard let block = completion else {return}
        selectedDate = combineDateWithTime(date: selectedDate!, time: timePicker.date)
       
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.dateStyle = .full
        df.timeStyle = .full
        print(df.string(from: selectedDate!))
        
        block(selectedDate!)
        dismiss(animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        selectedDate = date
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
         //(cell as! CastomFSCCell).clearSubviews()
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        var objects = [RBaseEvent]()
        objects = (RealmDBController.shared.loadEventsFor(date: date) as [REating]) as [RBaseEvent]
        objects += (RealmDBController.shared.loadEventsFor(date: date) as [RTrain]) as [RBaseEvent]
        objects += (RealmDBController.shared.loadEventsFor(date: date) as [RMeasuring]) as [RBaseEvent]
        objects += (RealmDBController.shared.loadEventsFor(date: date) as [RDrugging]) as [RBaseEvent]
        
        objects.sort(){$0.date < $1.date}
        
        let eventsType: [EventType] = objects.map(){ EventType(rawValue: $0.type)!}
        
        print("\(date.description) --- \(eventsType.description) --- \(eventsType.count)")
        
        (cell as! CastomFSCCell).configure(eventsType: eventsType)
    }
    
    
    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let castomCell = (cell as! CastomFSCCell)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).withAlphaComponent(0.2)
        //if position == .current {
            
            //cell.contentView.backgroundColor = .blue
            
        //}
    }
    

    
    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        mergedComponments.timeZone = timeComponents.timeZone
        
        return calendar.date(from: mergedComponments)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
