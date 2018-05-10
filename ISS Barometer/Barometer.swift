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
    var pressureReadings = [(Double, Double)]()
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()
    var initialPressureReading: Double!
    var initialTime: Double!
    var updateInitialPressureReading = false

    // REMOVE BEFORE DEPLOY <--
    var debugData:Double? = 100.0
    // -->
    
    func calcDeltaSum(_ dType: String) -> Double {
        var sum = 0.0
        if pressureReadings.count <= 1 {
            return 0
        }
        for idx in 1..<pressureReadings.count {
            let dp = pressureReadings[idx].0 - pressureReadings[idx-1].0
            let dt = pressureReadings[idx].1 - pressureReadings[idx-1].1
            sum += (dType == "dpdt" ? dp/dt : dt/dp)
        }
        return sum / Double(pressureReadings.count - 1)
    }
    
    func getDpdt() -> Double {
        return calcDeltaSum("dpdt")
    }
    
    func getDtdp() -> Double {
        return calcDeltaSum("dtdp")
    }
    
    func getDtdpStartTime() -> Double {
         return self.pressureReadings.first?.1 ?? Date().timeIntervalSince1970
    }
    
    func getDtdpEndTime() -> Double {
        return self.pressureReadings.last?.1 ?? Date().timeIntervalSince1970
    }
    
    func clearPressureReadings() {
        self.pressureReadings = [(Double, Double)]()
    }
    
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
    
    func startDisplayingPressureData(_ updateFunc:@escaping (Double, Double) -> (), _ setInitialPressure:@escaping (Double, Double) -> ()) {
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
            data, error in
            let kPa = data?.pressure.doubleValue
            let pressure = self.kPa2units(kPa: kPa!)
            let time = Date().timeIntervalSince1970
            if self.initialPressureReading == nil {
                self.initialPressureReading = pressure
                self.initialTime = time
                setInitialPressure(pressure, time)
            }
            if self.updateInitialPressureReading == true {
                setInitialPressure(self.initialPressureReading, self.initialTime)
                self.updateInitialPressureReading = false
            }
            self.pressureReadings.append((pressure, time))
            updateFunc(pressure, time)
        })
    }
    
    // REMOVE BEFORE DEPLOY
    func startDisplayingDebugData(_ updateFunc:@escaping (Double, Double) -> (), _ setInitialPressure:@escaping (Double, Double) -> ()) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            let time = Date().timeIntervalSince1970
            if (arc4random() % 2 == 0 || self.debugData! < 1){
                self.debugData = self.debugData! + drand48()
            } else {
                self.debugData = self.debugData! - drand48()
            }
            let pressure = self.kPa2units(kPa: self.debugData!)
            if self.initialPressureReading == nil {
                self.initialPressureReading = pressure
                setInitialPressure(pressure, time)
            }
            if self.updateInitialPressureReading == true {
                setInitialPressure(self.initialPressureReading, time)
            }
            self.pressureReadings.append((pressure, time))
            updateFunc(pressure, time)
        }
    }
    
    func startBarometerUpdates(_ updateFunc:@escaping (Double, Double) -> (), _ setInitialPressure:@escaping (Double, Double) -> ()) {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            startDisplayingPressureData(updateFunc, setInitialPressure)
        } else {
            startDisplayingDebugData(updateFunc, setInitialPressure)
        }
    }
}
