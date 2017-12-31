//
//  SettingsViewController.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/29/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    var settings:Settings!

    @IBOutlet weak var sigFigSlider: UISlider!
    @IBOutlet weak var sigFigValue: UILabel!
    @IBOutlet weak var unitPicker: UISegmentedControl!
    @IBOutlet weak var orientationPicker: UISegmentedControl!
    @IBOutlet weak var slidingScalePicker: UISwitch!
    @IBOutlet weak var runningWindowSlider: UISlider!
    @IBOutlet weak var runningWindowValue: UILabel!
    @IBOutlet weak var runningWindowOptions: UIView!
    @IBOutlet weak var runningWindowTable: UITableViewCell!
    
    @IBAction func sliderMoved(_ sender: Any) {
        let roundedValue = lroundf(sigFigSlider.value)
        (sender as AnyObject).setValue(Float(roundedValue), animated: true)
        sigFigValue.text = String(roundedValue)
        settings.sigFigs = roundedValue
    }
    
    @IBAction func unitPicked(_ sender: Any) {
        let selectedIdx = unitPicker.selectedSegmentIndex
        let selectedUnit = unitPicker.titleForSegment(at: selectedIdx)
        settings.units = selectedUnit!
    }
    
    @IBAction func orientationPicked(_ sender: Any) {
        let selectedIdx = orientationPicker.selectedSegmentIndex
        let selectedOrientation = orientationPicker.titleForSegment(at: selectedIdx)
        settings.orientation = selectedOrientation!
        UIDevice.current.setValue(selectedIdx + 1, forKey: "orientation")
    }
    
    @IBAction func slidingScalePicked(_ sender: Any) {
        settings?.slidingScale = slidingScalePicker.isOn
        initWindowSlider()
    }
    
    @IBAction func runningWindowSliderMoved(_ sender: Any) {
        let roundedValue = lroundf(runningWindowSlider.value)
        (sender as AnyObject).setValue(Float(roundedValue), animated: true)
        runningWindowValue.text = String(roundedValue*25)
        settings?.windowSize = roundedValue*25
    }
    
    func initSlider() {
        sigFigValue.text = String(describing: settings!.sigFigs)
        sigFigSlider.setValue(Float(settings.sigFigs), animated: true)
    }
    
    func initUnitPicker() {
        let unitPickerSegments = ["mmHg": 0, "psi": 1, "kPa": 2, "atm": 3]
        let segmentIdx = unitPickerSegments[settings.units]!
        unitPicker.selectedSegmentIndex = segmentIdx
    }
    
    func initOrientationPicker() {
        let orientationPickerSegments = ["Up": 0, "Down": 1, "Left": 2, "Right": 3]
        let segmentIdx = orientationPickerSegments[settings.orientation]!
        orientationPicker.selectedSegmentIndex = segmentIdx
    }
    
    func initSlidingScalePicker() {
        slidingScalePicker.setOn((settings?.slidingScale)!, animated: true)
    }
    
    func initWindowSlider() {
        if slidingScalePicker.isOn {
            runningWindowOptions.isHidden = false
            runningWindowTable.isHidden = false
        } else {
            runningWindowOptions.isHidden = true
            runningWindowTable.isHidden = true
        }
        runningWindowValue.text = String(describing: settings.windowSize)
        runningWindowSlider.setValue(Float(round(Double(settings.windowSize)/25.0)), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initSlider()
        initUnitPicker()
        initOrientationPicker()
        initSlidingScalePicker()
        initWindowSlider()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


