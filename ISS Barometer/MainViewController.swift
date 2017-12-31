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
    @IBOutlet weak var deltaTimestamp: UILabel!
    @IBOutlet weak var currentTimestamp: UILabel!
    
    var barometer = Barometer()
    lazy var chartViewController = childViewControllers[0] as! ChartViewController
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()

    @IBAction func resetPressed(_ sender: Any) {
        barometer.updateInitialReading()
    }
    
    func updateUI(pressure:Double, deltaPressure:Double, time:Double, resetWasPressed:Bool) {
        // Set Pressure Readings
        let fString = "%.\(settings.sigFigs)f \(settings.units)"
        pressureDisplay.text = String(format:fString, pressure)
        deltaPressureDisplay.text = String(format:fString, deltaPressure)
        let date = Date(timeIntervalSince1970: time)
        currentTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        if resetWasPressed {
            deltaTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        }
        // Update Chart
        chartViewController.updateChart(pressureReading: pressure, time: time)
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
        if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.settings = self.settings
            settingsVC.chartVC = self.chartViewController
        } else if segue.identifier == "ChartSegue" {
            let chartVC = segue.destination as! ChartViewController
            chartVC.settings = self.settings
        }
    }
}

