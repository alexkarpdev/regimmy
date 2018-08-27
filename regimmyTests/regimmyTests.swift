//
//  regimmyTests.swift
//  regimmyTests
//
//  Created by Natalia Sonina on 21.08.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import XCTest

@testable import regimmy

class regimmyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        print("log: seted up")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        print("log: teared down")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("log: tested Example")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
        
        print("log: tested Perfomanse")
    }
    
    func testViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dtvc = storyboard.instantiateViewController(withIdentifier: "DiaryTVC") as! DiaryTableViewController
        
        XCTAssertNotNil(dtvc)
        dtvc.viewDidLoad()
        
        print("log: pos objects: \(dtvc.posObjects.count)")
        print("log: sections: \(dtvc.tableView.numberOfSections)")
        
    }
    
    func testCreateNewEvent() {
        
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
        XCTAssertEqual(selectedPoso, newEvent)
        print("log: tested AddEvent")
    }
    
}
