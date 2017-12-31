//
//  Barometer.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/15/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

class Barometer {
    lazy var altimeter :CMAltimeter = CMAltimeter()
    var initialReading: Double?
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()

    // REMOVE BEFORE DEPLOY <--
    var debugData:Double? = 100.0
    // -->
    
    func kPa2units(kPa:Double) -> Double {
        switch settings.units {
            case "mmHg":
                return kPa * 7.50061683
            case "psi":
                return kPa / 6.89475729
            case "kPa":
                return kPa
            case "atm":
                return kPa / 101.325
            default:
                return kPa * 7.50061683
        }
    }
    
    func startDisplayingPressureData(updateFunc:@escaping (Double, Double, Double, Bool) -> ()) {
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
            data, error in
            let kPa = data?.pressure.doubleValue
            let pressure = self.kPa2units(kPa: kPa!)
            let time = Date().timeIntervalSince1970
            var resetWasPressed = false
            if self.initialReading == nil {
                self.initialReading = pressure
                resetWasPressed = true
            }
            let deltaPressure = pressure - self.initialReading!
            updateFunc(pressure, deltaPressure, time, resetWasPressed)
        })
    }
    
    // REMOVE BEFORE DEPLOY
    func startDisplayingDebugData(updateFunc:@escaping (Double, Double, Double, Bool) -> ()) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            let time = Date().timeIntervalSince1970
            var resetWasPressed = false
            if (arc4random() % 2 == 0 || self.debugData! < 1){
                self.debugData = self.debugData! + drand48()
            } else {
                self.debugData = self.debugData! - drand48()
            }
            if self.initialReading == nil {
                self.initialReading = self.debugData!
                resetWasPressed = true
            }
            let deltaDebug = (self.debugData! - self.initialReading!)
            updateFunc(self.kPa2units(kPa: self.debugData!), deltaDebug, time, resetWasPressed)
        }
    }
    
    func startBarometerUpdates(updateFunc:@escaping (Double, Double, Double, Bool) -> ()) {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            startDisplayingPressureData(updateFunc: updateFunc)
        } else {
            startDisplayingDebugData(updateFunc: updateFunc)
        }
    }
}
