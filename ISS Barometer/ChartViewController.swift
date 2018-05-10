//
//  LineChartViewController.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/2/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//
//  Running Graph function adapted from GitHub user thierryH24


import UIKit
import Charts

class ChartViewController: UIViewController {
    @IBOutlet weak var lineChartView: LineChartView!
    var barometer:Barometer!
    var dataEntries = [ChartDataEntry]()
    var startTime = 0.0
    var currentCount = 0
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()
    
    func adjustWindow(newEntry: ChartDataEntry) {
        if dataEntries.count >= settings.windowSize {
            let maxi = Double(newEntry.x)
            lineChartView.xAxis.axisMaximum = maxi
            lineChartView.xAxis.axisMinimum = maxi - Double(settings.windowSize)
        }
    }
    
    func addDataPoint(newEntry: ChartDataEntry) {
        dataEntries.append(newEntry)
        if settings.slidingScale {
            adjustWindow(newEntry: newEntry)
        } else {
            lineChartView.xAxis.resetCustomAxisMax()
            lineChartView.xAxis.resetCustomAxisMin()
        }
        currentCount += 1
        let lineChartDataSet = lineChartView.data!.dataSets[0] as! LineChartDataSet
        lineChartDataSet.values = dataEntries
    }
    
    func updateChartView() {
        lineChartView.data!.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        lineChartView.setNeedsDisplay()
    }
    
    func maintainAxes(pressureReading: Double) {
        if (settings.slidingScale) {
            lineChartView.xAxis.axisMinimum = startTime
            lineChartView.xAxis.axisMaximum = Double(settings.windowSize) + startTime
        }
    }
    
    func updateChart(pressureReading: Double, time: Double) {
        let newEntry = ChartDataEntry(x: time, y: pressureReading)
        if (currentCount == 0) {
            startTime = time
        }
        if (settings.slidingScale && currentCount <= settings.windowSize) {
            lineChartView.xAxis.axisMinimum = startTime
            lineChartView.xAxis.axisMaximum = Double(settings.windowSize) + startTime
        }
        addDataPoint(newEntry: newEntry)
        updateChartView()
    }
    
    func initChartProperties() {
        lineChartView.setScaleEnabled(true)
        lineChartView.noDataText = "You need to provide data for the chart."
        lineChartView.chartDescription!.enabled = false
    }
    
    func initAxes() {
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.legend.enabled = false
        lineChartView.xAxis.valueFormatter = XAxisValueFormatter()
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.rightAxis.axisMinimum = 0
        lineChartView.rightAxis.spaceTop = 0.5
        lineChartView.leftAxis.spaceTop = 0.5
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
    }
    
    func initChartData() {
        let lineChartDataSet = LineChartDataSet()
        lineChartDataSet.setColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1))
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawFilledEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        var dataSets = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        let data = LineChartData(dataSets: dataSets)
        lineChartView.data = data
    }
    
    func initChart() {
        initChartProperties()
        initAxes()
        initChartData()
    }
    
    func unitsToKpa(_ pressure: Double, _ oldUnits: String) -> Double {
        switch oldUnits {
        case "mmHg":
            return pressure / 7.50061683
        case "psi":
            return pressure * 6.89475729
        case "kPa":
            return pressure
        case "atm":
            return pressure * 101.325
        default:
            return pressure / 7.50061683
        }
    }

    func convertValue(_ value: Double, _ newUnits: String) -> Double {
        let oldUnits = settings.units
        let curKpa = unitsToKpa(value, oldUnits)
        
        switch newUnits {
        case "mmHg":
            return curKpa * 7.50061683
        case "psi":
            return curKpa / 6.89475729
        case "kPa":
            return curKpa
        case "atm":
            return curKpa / 101.325
        default:
            return curKpa * 7.50061683
        }
    }
    
    func convertEntry(_ entry: ChartDataEntry, _ newUnits: String) -> ChartDataEntry{
        entry.y = convertValue(entry.y, newUnits)
        return entry
    }
    
    func convertDataPoints(unit: String) {
        let lineChartDataSet = lineChartView.data!.dataSets[0] as! LineChartDataSet
        barometer.initialPressureReading = convertValue(barometer.initialPressureReading!, unit)
        barometer.updateInitialPressureReading = true
        dataEntries = dataEntries.map { value in convertEntry(value, unit) }
        lineChartDataSet.values = dataEntries
        updateChartView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
