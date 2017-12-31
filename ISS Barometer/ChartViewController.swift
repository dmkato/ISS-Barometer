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
    
    var dataEntries = [ChartDataEntry]()
    var settings:Settings!
    var startTime = 0.0
    var windowRunning = false
    var windowSize = 50
    var currentCount = 0
    var yAxisMin = 0.0
    var yAxisMax = 800.00
    
    func adjustWindow(newEntry: ChartDataEntry) {
        if dataEntries.count >= windowSize {
            let maxi = Double(newEntry.x)
            lineChartView.xAxis.axisMaximum = maxi
            lineChartView.xAxis.axisMinimum = maxi - Double(windowSize)
        }
        lineChartView.moveViewToX(Double(currentCount))
    }
    
    func addDataPoint(newEntry: ChartDataEntry) {
        dataEntries.append(newEntry)
        
        if windowRunning {
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
        if (windowRunning) {
            lineChartView.xAxis.axisMinimum = startTime
            lineChartView.xAxis.axisMaximum = Double(windowSize) + startTime
        }
        yAxisMin = 100.0 * round((pressureReading - 100.0)/100.0)
        lineChartView.leftAxis.axisMinimum = yAxisMin
        lineChartView.rightAxis.axisMinimum = yAxisMin
        
        yAxisMax = 50.0 * round((pressureReading + 50.0)/50.0)
        lineChartView.leftAxis.axisMaximum = yAxisMax
        lineChartView.rightAxis.axisMaximum = yAxisMax
    }
    
    func updateChart(pressureReading: Double, time: Double) {
        let newEntry = ChartDataEntry(x: time, y: pressureReading)
        if (currentCount == 0) {
            startTime = time
        }
        if (currentCount <= windowSize) {
            maintainAxes(pressureReading: pressureReading)
        }
        if (pressureReading >= yAxisMax - 15) {
            yAxisMax = yAxisMax + 50.0
            lineChartView.leftAxis.axisMaximum = yAxisMax
            lineChartView.rightAxis.axisMaximum = yAxisMax
        }
        if (pressureReading <= yAxisMin + 20) {
            yAxisMin = yAxisMin - 100.0
            lineChartView.leftAxis.axisMinimum = yAxisMin
            lineChartView.rightAxis.axisMinimum = yAxisMin
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
        print(settings.slidingScale)
        windowRunning = settings.slidingScale
        if windowRunning {
            windowSize = settings.runningWindowSize
        }
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

    func convertValue(_ value: ChartDataEntry, _ newUnits: String) -> ChartDataEntry {
        let oldUnits = settings.units
        let curKpa = unitsToKpa(value.y, oldUnits)
        
        switch newUnits {
        case "mmHg":
            value.y = curKpa * 7.50061683
        case "psi":
            value.y = curKpa / 6.89475729
        case "kPa":
            value.y = curKpa
        case "atm":
            value.y = curKpa / 101.325
        default:
            value.y = curKpa * 7.50061683
        }
        return value
    }
    
    func convertDataPoints(unit: String) {
        let lineChartDataSet = lineChartView.data!.dataSets[0] as! LineChartDataSet
        dataEntries = dataEntries.map { value in convertValue(value, unit) }
        lineChartDataSet.values = dataEntries
        updateChartView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
    }
    override func viewWillAppear(_ animated: Bool) {
        windowRunning = settings.slidingScale
        if windowRunning {
            windowSize = settings.runningWindowSize
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
