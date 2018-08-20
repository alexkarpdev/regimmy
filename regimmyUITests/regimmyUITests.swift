//
//  regimmyUITests.swift
//  regimmyUITests
//
//  Created by Natalia Sonina on 20.08.2018.
//  Copyright © 2018 Natalia Sonina. All rights reserved.
//

import XCTest

class regimmyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
                // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testInput2() {
        
        let app = XCUIApplication()
        app.navigationBars["Дневник"].buttons["addEvent"].tap()
        
        let dt = app.tables["diaryTable"]
        let startCount = dt.
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Тренировку"]/*[[".cells.staticTexts[\"Тренировку\"]",".staticTexts[\"Тренировку\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Название"]/*[[".cells.textFields[\"Название\"]",".textFields[\"Название\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Название"]/*[[".cells.textFields[\"Название\"]",".textFields[\"Название\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("11qq22wesssssw")
        
        app.navigationBars["Новую Тренировку"].buttons["Сохранить"].tap()
        
        XCTAssertEqual(dt.cells.count, startCount)
        
        
    }
    
    func testInput() {
        
        
        let app = XCUIApplication()
        app.navigationBars["Дневник"].buttons["addEvent"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Тренировку"]/*[[".cells.staticTexts[\"Тренировку\"]",".staticTexts[\"Тренировку\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Название"]/*[[".cells.textFields[\"Название\"]",".textFields[\"Название\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let qKey = app/*@START_MENU_TOKEN@*/.keys["q"]/*[[".keyboards.keys[\"q\"]",".keys[\"q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        qKey.tap()
        
        let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()
        app.navigationBars["Новую Тренировку"].buttons["Сохранить"].tap()
        
        
    }
    func testCreateNewExEvent() {
        
        
        
        let app = XCUIApplication()
        app.navigationBars["Дневник"].buttons["addEvent"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Тренировку"]/*[[".cells.staticTexts[\"Тренировку\"]",".staticTexts[\"Тренировку\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        
        let insertButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Insert"]/*[[".cells.buttons[\"Insert\"]",".buttons[\"Insert\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        insertButton.tap()
        
        let button = app.navigationBars["Выберите"].buttons["Готово"]
        button.tap()
        insertButton.tap()
        button.tap()
        app.navigationBars["Новую Тренировку"].buttons["Отмена"].tap()
        app.navigationBars["Тренировку"].buttons["Отмена"].tap()
       
       
        
    }
    
}
