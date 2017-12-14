//
//  LineChartViewController.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/2/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    @IBOutlet weak var lineChartView: LineChartView!
    var startingTime: Double = 0
    var dataEntries = [ChartDataEntry]()
    
    func setTime(time: Double) -> Double{
        if startingTime == 0 {
            startingTime = time
        }
        return time - startingTime
    }
    
    func addDataPoint(newEntry: ChartDataEntry) {
        dataEntries.append(newEntry)
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
        let elapsedTime = setTime(time: time)
        let newEntry = ChartDataEntry(x: elapsedTime,
                                      y: pressureReading)
        addDataPoint(newEntry: newEntry)
        updateChartView()
    }
    
    func initChartProperties() {
        lineChartView.setScaleEnabled(true)
        lineChartView.noDataText = "You need to provide data for the chart."
        lineChartView.chartDescription?.enabled = false
    }
    
    func initAxes() {
        lineChartView.leftAxis.axisMaximum = 15
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.rightAxis.axisMaximum = 15
        lineChartView.rightAxis.axisMinimum = 0
        lineChartView.xAxis.labelPosition = .bottom
    }
    
    func initChartData() {
        let lineChartDataSet = LineChartDataSet()
        lineChartDataSet.setColor(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1))
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawFilledEnabled = false
        lineChartDataSet.drawValuesEnabled = false
//        lineChartDataSet.mode = .cubicBezier
        
        var dataSets = [lineChartDataSet]
        dataSets.append(lineChartDataSet)
        
        let data = LineChartData(dataSets: dataSets)
        lineChartView.data = data
    }
    
    func initChart() {
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

    // This is called before sequeing to the settings view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
