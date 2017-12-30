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
    var settings:Settings?

    var windowRunning = false
    var windowSize = 50
    var currentCount = 0.0
    
    var yAxisMin:Double = 0.0
    var yAxisMax:Double = 800.00
    
    func addDataPoint(newEntry: ChartDataEntry) {
        dataEntries.append(newEntry)
        
        if windowRunning {
            if dataEntries.count >= windowSize
            {
                let maxi = Double(newEntry.x)
                lineChartView.xAxis.axisMaximum = maxi
                lineChartView.xAxis.axisMinimum = maxi - Double(windowSize)
            }
            
            lineChartView.moveViewToX(Double(currentCount))
        }
        
        currentCount = currentCount + 1
        
        var lineChartDataSet = LineChartDataSet()
        lineChartDataSet = (lineChartView.data?.dataSets[0] as? LineChartDataSet)!
        lineChartDataSet.values = dataEntries
    }
    
    func updateChartView() {
        lineChartView.data?.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        lineChartView.setNeedsDisplay()
    }
    
    func updateChart(pressureReading: Double, time: Double) {
        let newEntry = ChartDataEntry(x: time, y: pressureReading)
        if (currentCount == 0.0) {
            if (windowRunning) {
                lineChartView.xAxis.axisMaximum = time
                lineChartView.xAxis.axisMaximum = Double(windowSize) + time
            } else {
                lineChartView.leftAxis.axisMinimum = 0
                lineChartView.rightAxis.axisMinimum = 0
            }
            yAxisMin = 100.0 * round((pressureReading - 100.0)/100.0)
            lineChartView.leftAxis.axisMinimum = yAxisMin
            lineChartView.rightAxis.axisMinimum = yAxisMin
            
            yAxisMax = 50.0 * round((pressureReading + 50.0)/50.0)
            lineChartView.leftAxis.axisMaximum = yAxisMax
            lineChartView.rightAxis.axisMaximum = yAxisMax
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
        lineChartView.chartDescription?.enabled = false
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
        windowRunning = (settings?.slidingScale)!
        print(windowRunning)
        
        initChartProperties()
        initAxes()
        initChartData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
