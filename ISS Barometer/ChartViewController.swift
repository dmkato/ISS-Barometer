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
    var chartData: ChartData = ChartData()
    
    func updateChart(pressureReading: Double, time: NSDate) {
        let newEntry = ChartDataEntry(x: time.timeIntervalSince1970, y: pressureReading)
        self.chartData.addEntry(newEntry, dataSetIndex: 0)
        lineChartView.notifyDataSetChanged()
    }
    
    func setChart() {
        lineChartView.noDataText = "You need to provide data for the chart."
        chartData.addDataSet(LineChartDataSet(values: nil, label: "Pressure"))
        self.lineChartView.data = self.chartData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setChart()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
