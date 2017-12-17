//
//  XAxisValueFormatter.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/17/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import Foundation
import Charts

class XAxisValueFormatter: NSObject, IAxisValueFormatter {
     func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .medium)
    }
}
