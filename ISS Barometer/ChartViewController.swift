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
    var chartData = ChartData()
    var startingTime: Double = 0
    
    func updateChart(pressureReading: Double, time: Double) {
        if startingTime == 0 {
            startingTime = time
        }
        let elapsedTime = time - startingTime
        let newEntry = ChartDataEntry(x: elapsedTime,
                                      y: pressureReading)
        chartData.addEntry(newEntry, dataSetIndex: 0)
        chartData.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        lineChartView.setNeedsDisplay()
    }
    
    func setChartData() {
        let lineChartDataSet = LineChartDataSet(values: nil,
                                                label: "Pressure")
        chartData.addDataSet(lineChartDataSet)
        lineChartView.data = chartData
    }
    
    func setChartProperties() {
        lineChartView.setScaleEnabled(true)
        lineChartView.noDataText = "You need to provide data for the chart."
        lineChartView.chartDescription?.enabled = false
    }
    
    func setAxes() {
        lineChartView.leftAxis.axisMaximum = 15
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.rightAxis.axisMaximum = 15
        lineChartView.rightAxis.axisMinimum = 0
        lineChartView.xAxis.labelPosition = .bottom
    }
    
    func setChart() {
        setChartData()
        setChartProperties()
        setAxes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart()
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
