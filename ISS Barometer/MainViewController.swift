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
    @IBOutlet weak var dpdtDisplay: UILabel!
    @IBOutlet weak var dtdpDisplay: UILabel!
    @IBOutlet weak var dpdtTimestamp: UILabel!
    @IBOutlet weak var pressureDisplayUnit: UILabel!
    @IBOutlet weak var deltaPressureDisplayUnit: UILabel!
    @IBOutlet weak var dpdtDisplayUnit: UILabel!
    @IBOutlet weak var dtdpDisplayUnit: UILabel!
    @IBOutlet weak var deltaResetButton: UIButton!
    @IBOutlet weak var dpdtResetButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    
    var barometer = Barometer()
    var screenIsLocked = false
    lazy var chartViewController = childViewControllers[0] as! ChartViewController
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()

    @IBAction func resetPressed(_ sender: Any) {
        barometer.updateInitialReading()
    }
    
    @IBAction func dpdtResetPressed(_ sender: Any) {
    }
    
    @IBAction func screenLockPressed(_ sender: Any) {
        screenIsLocked = !screenIsLocked
        lockButton.setTitle(screenIsLocked ? "Unlock" : "Lock", for: .normal)
        settingsButton.isEnabled = !screenIsLocked
        dpdtResetButton.isEnabled = !screenIsLocked
        deltaResetButton.isEnabled = !screenIsLocked
        chartView.isUserInteractionEnabled = !screenIsLocked
    }
    
    func updateUI(pressure:Double, deltaPressure:Double, time:Double, resetWasPressed:Bool) {
        // Set Pressure Readings
        
        let fString = "%.\(settings.sigFigs)f"
        pressureDisplayUnit.text = String(settings.units)
        dtdpDisplayUnit.text = String(settings.units)
        dpdtDisplayUnit.text = String(settings.units)
        pressureDisplay.text = String(format:fString, pressure)
        deltaPressureDisplay.text = String(format:fString, deltaPressure)
        deltaPressureDisplayUnit.text = String(settings.units)
        let date = Date(timeIntervalSince1970: time)
        currentTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        if resetWasPressed {
            deltaTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
            dpdtDisplay.text = "0.0000"
            dtdpDisplay.text = "0.0000"
        }
        // Update Chart
        chartViewController.updateChart(pressureReading: pressure, time: time)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barometer.settings = self.settings
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
            settingsVC.chartVC = self.chartViewController
        } else if segue.identifier == "ChartSegue" {
            let chartVC = segue.destination as! ChartViewController
            chartVC.barometer = barometer
        }
    }
}

