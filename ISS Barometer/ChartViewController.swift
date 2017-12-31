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
    var currentCount = 0
    
    func adjustWindow(newEntry: ChartDataEntry) {
        if dataEntries.count >= settings.windowSize {
            let maxi = Double(newEntry.x)
            lineChartView.xAxis.axisMaximum = maxi
            lineChartView.xAxis.axisMinimum = maxi - Double(settings.windowSize)
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
        var lineChartDataSet = LineChartDataSet()
        lineChartDataSet = lineChartView.data!.dataSets[0] as! LineChartDataSet
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
            lineChartView.xAxis.axisMaximum = Double(settings.windowSize) + startTime
        }
    }
    
    func updateChart(pressureReading: Double, time: Double) {
        let newEntry = ChartDataEntry(x: time, y: pressureReading)
        if (currentCount == 0) {
            startTime = time
        }
        if (windowRunning && currentCount <= settings.windowSize) {
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
        windowRunning = settings.slidingScale
        initChartProperties()
        initAxes()
        initChartData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
    }
    override func viewWillAppear(_ animated: Bool) {
        windowRunning = settings.slidingScale
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
