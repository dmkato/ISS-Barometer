//
//  ViewControllerTests.swift
//  ISS BarometerTests
//
//  Created by Daniel Kato on 12/11/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import XCTest
import CoreMotion
@testable import ISS_Barometer

class MainViewControllerTests: XCTestCase {
    var mainViewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUpdateUI() {
        let testMmHg = 700.1
        let testDeltaMmHg = 0.3
        let testTime = 20.0
        mainViewController.updateUI(mmHg: testMmHg, deltaMmHg: testDeltaMmHg, time: testTime)
        XCTAssert(mainViewController.pressureDisplay.text == "700.1000 mmHg")
        XCTAssert(mainViewController.deltaPressureDisplay.text == "0.3000 mmHg")
    }
    
}

