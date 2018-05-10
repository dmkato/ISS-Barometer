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
    @IBOutlet weak var initialPressureDisplay: UILabel!
    @IBOutlet weak var initialPressureTimestamp: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var yAxisLabel: UILabel!
    @IBOutlet weak var currentTimestamp: UILabel!
    @IBOutlet weak var dpdtDisplay: UILabel!
    @IBOutlet weak var dtdpDisplay: UILabel!
    @IBOutlet weak var pressureDisplayUnit: UILabel!
    @IBOutlet weak var initialPressureDisplayUnit: UILabel!
    @IBOutlet weak var dpdtDisplayUnit: UILabel!
    @IBOutlet weak var dtdpDisplayUnit: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var integrationInterval: UILabel!
    @IBOutlet weak var tResDisplay: UILabel!
    
    var barometer = Barometer()
    var screenIsLocked = false
    var dpdtResetWasPressed = false
    
    var currentPressure = 0.0
    var tResTimer: Timer!
    var tResTotal = 0.0
    
    lazy var chartViewController = childViewControllers[0] as! ChartViewController
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()
    
    @IBAction func screenLockPressed(_ sender: Any) {
        screenIsLocked = !screenIsLocked
        lockButton.setTitle(screenIsLocked ? "Unlock" : "Lock", for: .normal)
        settingsButton.isEnabled = !screenIsLocked
        chartView.isUserInteractionEnabled = !screenIsLocked
    }

    func updateTRes(){
        let start = barometer.unit2kPa(pres: currentPressure)
        let rate = barometer.getDpdt()
        if rate < 0 {
            let buffer = settings.pressureBuffer // In kPa
            tResTotal = -((start - buffer) / rate)
            if tResTimer != nil {
                tResTimer.invalidate()
            }
            startTResTimer()
            print(tResTotal, " seconds")
        }
    }
    
    func secToString(seconds: Double) -> String {
        let intSec = Int(seconds)
        let hours = Int(intSec / 3600)
        let mins = Int((intSec % 3600) / 60)
        let secs = Int((intSec % 3600) % 60)
        let ms = Int(seconds.truncatingRemainder(dividingBy: 1.0) * 60.0)
        return String(format: "%02d:%02d:%02d:%02d", hours, mins, secs, ms)
    }
    
    func startTResTimer() {
        tResTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTResTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTResTimer(){
        tResDisplay.text =  secToString(seconds: tResTotal)
        tResTotal -= 0.1
        if tResTotal < 0.01 {
            endTResTimer()
        }
    }
    
    func endTResTimer(){
        tResTimer.invalidate()
    }
    
    func updateUI(pressure:Double, time:Double) {
        let date = Date(timeIntervalSince1970: time)
        currentPressure = pressure
        pressureDisplay.text = String(format:"%.\(settings.sigFigs)f", pressure)
        currentTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        dpdtDisplay.text = String(format:"%.\(settings.sigFigs)f", barometer.getDpdt())
        dtdpDisplay.text = String(format:"%.\(settings.sigFigs)f", barometer.getDtdp())
        chartViewController.updateChart(pressureReading: pressure, time: time)
        updateTRes()
    }
    
    func setInitialPressure(pressure: Double, time: Double) {
        let date = Date(timeIntervalSince1970: time)
        initialPressureDisplay.text = String(format:"%.\(settings.sigFigs)f", pressure)
        initialPressureTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
    }
    
    func adjustAxisLabels() {
        yAxisLabel.text = "Pressure (\(settings.units))"
        yAxisLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        yAxisLabel.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barometer.settings = self.settings
        barometer.startBarometerUpdates(updateUI, setInitialPressure)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDisplayUnits() {
        pressureDisplayUnit.text = String(settings.units)
        dtdpDisplayUnit.text = "Sec/" + String(settings.units)
        dpdtDisplayUnit.text = String(settings.units) + "/Sec"
        initialPressureDisplayUnit.text = String(settings.units)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDisplayUnits()
        integrationInterval.text = String(settings.runningIntegrationInterval)
        adjustAxisLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsSegue" {
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.chartVC = self.chartViewController
            settingsVC.barometer = barometer
        } else if segue.identifier == "ChartSegue" {
            let chartVC = segue.destination as! ChartViewController
            chartVC.barometer = barometer
        }
    }
}

