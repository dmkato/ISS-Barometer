//
//  Csv.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 5/9/18.
//  Copyright © 2018 ISSBarometer. All rights reserved.
//

import Foundation
import Charts

class Csv {
    func dataEntriesToCsv(_ dataEntries: [ChartDataEntry]) -> String {
        var csvString = "Pressure (kPa), Time\n"
        for d in dataEntries {
            let date = Date(timeIntervalSince1970: d.x)
            let rowString = "\(d.y),\(date)\n"
            csvString += rowString
        }
        return csvString
    }
    
    func createCsvFile(_ dataEntries: [ChartDataEntry]) -> URL? {
        let csvText = dataEntriesToCsv(dataEntries)
        print(csvText)
        let fileName = "ISS_Barometer_Data.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        return path
    }
}
