//
//  ISS_BarometerTests.swift
//  ISS BarometerTests
//
//  Created by Daniel Kato on 11/27/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import XCTest
import Charts
@testable import ISS_Barometer

class ISS_BarometerTests: XCTestCase {
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        storyboard = UIStoryboard(name: "Main", bundle: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewDataPoint() {
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.loadViewIfNeeded()
        let testMmHg = 700.1
        let testDeltaMmHg = 0.3
        let testTime = 20.0
        mainViewController.updateUI(mmHg: testMmHg, deltaMmHg: testDeltaMmHg, time: testTime)
        XCTAssert(mainViewController.pressureDisplay.text == "700.1000 mmHg")
        XCTAssert(mainViewController.deltaPressureDisplay.text == "0.3000 mmHg")
        let lineChartDataSet = (mainViewController.chartViewController.lineChartView.data?.dataSets[0] as? LineChartDataSet)!
        print(lineChartDataSet.values[0].x)
        print(lineChartDataSet.values[0].y)
        XCTAssert(lineChartDataSet.values[0].x == 0.0)
        XCTAssert(lineChartDataSet.values[0].y == testMmHg)
    }
}
