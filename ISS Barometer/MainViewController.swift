//
//  ViewController.swift
//  Barometer Test
//
//  Created by Daniel Kato on 10/21/17.
//  Copyright © 2017 Daniel Kato. All rights reserved.
//

import UIKit
import Charts

class MainViewController: UIViewController {
    @IBOutlet weak var pressureDisplay: UILabel!
    @IBOutlet weak var deltaPressureDisplay: UILabel!
    @IBOutlet weak var chartView: UIView!
    var significantDigits:Int = 4
    var barometer = Barometer()
    lazy var chartViewController: ChartViewController = childViewControllers[0] as! ChartViewController

    @IBAction func resetPressed(_ sender: Any) {
        barometer.updateInitialReading()
    }
    
    func updateUI(mmHg:Double, deltaMmHg:Double, time:Double) {
        // Set Pressure Readings
        let fString = "%.\(significantDigits)f mmHg"
        pressureDisplay.text = String(format:fString, mmHg)
        deltaPressureDisplay.text = String(format:fString, deltaMmHg)

        // Update Chart
        chartViewController.updateChart(pressureReading: mmHg, time: time)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barometer.startBarometerUpdates(updateFunc: updateUI)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This is called before sequeing to the settings view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

