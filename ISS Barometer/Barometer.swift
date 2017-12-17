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
    var mmHg:Double? = 0.0
    var prevMmHg:Double? = 0.0
    var deltaMmHg:Double? = 0.0
    var prevTime:Double? = 0.0
    var time:Double? = 0.0
    
    // REMOVE BEFORE DEPLOY <--
    var prevDebugData:Double? = 0.0
    var debugData:Double? = 700.0
    var deltaDebug:Double? = 0.0
    // -->
    
    func kPa2mmHg(kPa:Double) -> Double {
        return kPa * 7.50061683
    }
    
    func startDisplayingPressureData(updateFunc:@escaping (Double, Double, Double) -> ()) {
        altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
            data, error in
            let kPa = data?.pressure.doubleValue
            self.prevTime = self.time
            self.time = Date().timeIntervalSince1970
            self.prevMmHg = self.mmHg
            self.mmHg = self.kPa2mmHg(kPa: kPa!)
            self.deltaMmHg = (self.mmHg! - self.prevMmHg!) / (self.time! - self.prevTime!)
            updateFunc(self.mmHg!, self.deltaMmHg!, self.time!)
        })
    }
    
    // REMOVE BEFORE DEPLOY
    func startDisplayingDebugData(updateFunc:@escaping (Double, Double, Double) -> ()) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
            self.prevTime = self.time
            self.time = Date().timeIntervalSince1970
            if (arc4random() % 2 == 0 || self.debugData! < 1){
                self.debugData = self.debugData! + drand48()
            } else {
                self.debugData = self.debugData! - drand48()
            }
            self.deltaDebug = (self.debugData! - self.prevDebugData!) / (self.time! - self.prevTime!)
            self.prevDebugData = self.debugData!
            updateFunc(self.debugData!, self.deltaDebug!, self.time!)
        }
    }
    
    func startBarometerUpdates(updateFunc:@escaping (Double, Double, Double) -> ()) {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            startDisplayingPressureData(updateFunc: updateFunc)
        } else {
            startDisplayingDebugData(updateFunc: updateFunc)
        }
    }
}
