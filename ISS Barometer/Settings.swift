//
//  Settings.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/29/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import Foundation

class Settings {
    var units = "mmHg"
    var sigFigs = 4
    var orientation = "Up"
    var slidingScale = false
    var slidingScaleThreshold = 20
    var runningWindowSize = 50
}
