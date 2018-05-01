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
    @IBOutlet weak var yAxisLabel: UILabel!
    @IBOutlet weak var deltaTimestamp: UILabel!
    @IBOutlet weak var currentTimestamp: UILabel!
    @IBOutlet weak var dpdtDisplay: UILabel!
    @IBOutlet weak var dtdpDisplay: UILabel!
    @IBOutlet weak var dpdtToTimestamp: UILabel!
    @IBOutlet weak var dpdtFromTimestamp: UILabel!
    @IBOutlet weak var pressureDisplayUnit: UILabel!
    @IBOutlet weak var deltaPressureDisplayUnit: UILabel!
    @IBOutlet weak var dpdtDisplayUnit: UILabel!
    @IBOutlet weak var dtdpDisplayUnit: UILabel!
    @IBOutlet weak var deltaResetButton: UIButton!
    @IBOutlet weak var dpdtResetButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    
    @IBOutlet weak var tResOutput: UILabel!
    
    var barometer = Barometer()
    var screenIsLocked = false
    var deltaResetWasPressed = false
    var dpdtResetWasPressed = false
    
    lazy var chartViewController = childViewControllers[0] as! ChartViewController
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()

    @IBAction func deltaResetPressed(_ sender: Any) {
        barometer.updateInitialDeltaReading()
        deltaResetWasPressed = true
    }
    
    @IBAction func dpdtResetPressed(_ sender: Any) {
        dpdtDisplay.text = String(format:"%.\(settings.sigFigs)f", barometer.getDpdt())
        dtdpDisplay.text = String(format:"%.\(settings.sigFigs)f", barometer.getDtdp())
        let startDate = Date(timeIntervalSince1970: barometer.getDtdpStartTime())
        let endDate = Date(timeIntervalSince1970: barometer.getDtdpEndTime())
        dpdtFromTimestamp.text =  DateFormatter.localizedString(from: startDate, dateStyle: .none, timeStyle: .medium)
        dpdtToTimestamp.text = DateFormatter.localizedString(from: endDate, dateStyle: .none, timeStyle: .medium)
        let pressure = barometer.clearPressureReadings()
        updateTRes(start: pressure.0)
    }
    
    @IBAction func screenLockPressed(_ sender: Any) {
        screenIsLocked = !screenIsLocked
        lockButton.setTitle(screenIsLocked ? "Unlock" : "Lock", for: .normal)
        settingsButton.isEnabled = !screenIsLocked
        dpdtResetButton.isEnabled = !screenIsLocked
        deltaResetButton.isEnabled = !screenIsLocked
        chartView.isUserInteractionEnabled = !screenIsLocked
    }
    
    func handleDeltaReset(_ date: Date) {
        if deltaResetWasPressed || barometer.firstReading {
            deltaTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
            deltaResetWasPressed = false
        }
    }
    
    func updateTRes(start: Double){
        let dPdt = barometer.getDpdt()
        if dPdt > 0 {
            let buffer = 58.66 // In kPa
            let tRes = (start - buffer) / dPdt
            tResOutput.text = String(format:"TRes: %ld", tRes)
            print(tRes, " seconds")
        }
    }
    
    func updateUI(pressure:Double, deltaPressure:Double, time:Double) {
        let date = Date(timeIntervalSince1970: time)
        pressureDisplay.text = String(format:"%.\(settings.sigFigs)f", pressure)
        deltaPressureDisplay.text = String(format:"%.\(settings.sigFigs)f", deltaPressure)
        currentTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        handleDeltaReset(date)
        chartViewController.updateChart(pressureReading: pressure, time: time)
    }
    
    func adjustAxisLabels() {
        yAxisLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        yAxisLabel.text = "Pressure (\(settings.units))"
        yAxisLabel.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustAxisLabels()
        barometer.settings = self.settings
        barometer.startBarometerUpdates(updateFunc: updateUI)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDisplayUnits() {
        pressureDisplayUnit.text = String(settings.units)
        dtdpDisplayUnit.text = "Sec/" + String(settings.units)
        dpdtDisplayUnit.text = String(settings.units) + "/Sec"
        deltaPressureDisplayUnit.text = String(settings.units)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDisplayUnits()
    }
    
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

