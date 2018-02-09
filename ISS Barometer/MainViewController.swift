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
    
    var barometer = Barometer()
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
        dpdtResetWasPressed = true
    }
    
    func handleDpdtReset(_ date: Date) {
        if dpdtResetWasPressed {
            dpdtDisplay.text = String(format:"%.\(settings.sigFigs)f", barometer.getDpdt())
            dtdpDisplay.text = String(format:"%.\(settings.sigFigs)f", barometer.getDtdp())
            dpdtTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
            dpdtResetWasPressed = false
        }
    }
    
    func handleDeltaReset(_ date: Date) {
        if deltaResetWasPressed {
            deltaTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
            deltaResetWasPressed = false
        }
    }
    
    func updateUI(pressure:Double, deltaPressure:Double, time:Double) {
        let date = Date(timeIntervalSince1970: time)
        pressureDisplay.text = String(format:"%.\(settings.sigFigs)f", pressure)
        deltaPressureDisplay.text = String(format:"%.\(settings.sigFigs)f", deltaPressure)
        currentTimestamp.text = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
        handleDeltaReset(date)
        handleDpdtReset(date)
        chartViewController.updateChart(pressureReading: pressure, time: time)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

