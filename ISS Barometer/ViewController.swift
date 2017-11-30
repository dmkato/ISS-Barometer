//
//  ViewController.swift
//  Barometer Test
//
//  Created by Daniel Kato on 10/21/17.
//  Copyright © 2017 Daniel Kato. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var pressureDisplay: UILabel!
    @IBOutlet weak var deltaPressureDisplay: UILabel!
    lazy var altimeter :CMAltimeter = CMAltimeter()
    var mmHg:Double? = 0.0
    var prevMmHg:Double? = 0.0
    var deltaMmHg:Double? = 0.0
    var prevTime:NSDate? = NSDate()
    var time:NSDate? = NSDate()
    var significantDigits:Int = 4
    
    func kPa2mmHg(kPa:Double) -> Double {
        let atm:Double = kPa * 101.325
        let mmHg:Double = atm / 760.0
        return mmHg
    }
    
    func handlePressureReading(data:CMAltitudeData) {
        let kPa = data.pressure.doubleValue
        self.prevTime = self.time
        self.time = NSDate()
        self.prevMmHg = self.mmHg
        self.mmHg = self.kPa2mmHg(kPa: kPa)
        self.deltaMmHg = (self.mmHg! - self.prevMmHg!) / (self.time?.timeIntervalSince(self.prevTime! as Date))!
        
        let fString = "%.\(self.significantDigits)f mmHg"
        self.pressureDisplay.text = String(format:fString, (self.mmHg)!)
        self.deltaPressureDisplay.text = String(format:fString, (self.deltaMmHg)!)
    }
    
    func startDisplayingPressureData() {
        self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
            self.handlePressureReading(data: data!)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CMAltimeter.isRelativeAltitudeAvailable() {
            self.startDisplayingPressureData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

