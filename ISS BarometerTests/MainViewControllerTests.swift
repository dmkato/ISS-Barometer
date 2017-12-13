//
//  ViewControllerTests.swift
//  ISS BarometerTests
//
//  Created by Daniel Kato on 12/11/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import XCTest
@testable import ISS_Barometer

class MainViewControllerTests: XCTestCase {
    var mainViewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        mainViewController = MainViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testKpaToMmhg() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let testValue = 1.0
        let expected = 0.13332236842105263
        let actual = mainViewController.kPa2mmHg(kPa: testValue)
        XCTAssert(actual == expected, "1.0 kPa should equal 7.500616 mmHg")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
