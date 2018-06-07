//
//  CalendarViewController.swift
//  regimmy
//
//  Created by Natalia Sonina on 23.04.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import UIKit
//import FSCalendar


class CalendarViewController: UIViewController, FSCalendarDelegate {
    
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
    
    var completion: ((Date)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        timePicker.isHidden = isPickerHidden
        timePicker.timeZone = TimeZone.current
        calendarView.delegate = self
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
