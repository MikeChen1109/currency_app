//
//  CurrencyAppUITests.swift
//  CurrencyAppUITests
//
//  Created by 逸唐陳 on 2023/7/24.
//

import XCTest

final class CurrencyAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAmountTextField() throws {
        let testAmount = "123"
        
        let app = XCUIApplication()
        app.launch()
        
        let amountTextField = app.textFields["amountTextField"]
        XCTAssertTrue(amountTextField.exists)
        amountTextField.tap()
        amountTextField.typeText(testAmount)
        XCTAssertEqual(testAmount, amountTextField.value as! String)
    }
    
    func testCollectionView() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionView = app.collectionViews["currencyCollectionView"]
        XCTAssertTrue(collectionView.waitForExistence(timeout: 3))
        let cell = collectionView.cells.element(matching: .cell, identifier: "Cell_0")
        XCTAssertTrue(cell.exists)
        let label = cell.staticTexts["currencyTitle"].label
        XCTAssertEqual(label, "AED")
    }
    
    func testDropDownButton() throws {
        let testCurrency = "AMD"
        
        let app = XCUIApplication()
        app.launch()
        
        let pickerField = app.textFields["currencyPickerField"]
        XCTAssertTrue(pickerField.exists)
        pickerField.tap()
        
        let pickerView = app.pickers["currencyPickerView"]
        XCTAssertTrue(pickerView.exists)
        pickerView.pickerWheels.element.adjust(toPickerWheelValue: "AMD")
        
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        
        XCTAssertEqual(pickerField.value as! String, testCurrency)
    }
}
