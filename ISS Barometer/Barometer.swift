//
//  Barometer.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/15/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import Foundation
import CoreMotion

class Barometer {
    lazy var altimeter :CMAltimeter = CMAltimeter()
    var initialReading:Double?
    
    // REMOVE BEFORE DEPLOY <--
    var debugData:Double? = 700.0
    // -->
    
    func kPa2mmHg(kPa:Double) -> Double {
        return kPa * 7.50061683
    }
    
    func updateInitialReading() {
        self.initialReading = nil
    }
    
    func startDisplayingPressureData(updateFunc:@escaping (Double, Double, Double, Bool) -> ()) {
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
            data, error in
            let kPa = data?.pressure.doubleValue
            let mmHg = self.kPa2mmHg(kPa: kPa!)
            let time = Date().timeIntervalSince1970
            var resetWasPressed = false
            if self.initialReading == nil {
                self.initialReading = mmHg
                resetWasPressed = true
            }
            let deltaMmHg = (mmHg - self.initialReading!)
            updateFunc(mmHg, deltaMmHg, time, resetWasPressed)
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
            updateFunc(self.debugData!, deltaDebug, time, resetWasPressed)
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
