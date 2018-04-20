//
//  GraphController.swift
//  GIT SIT
//
//  Created by OrangeWorksMacTwo on 4/12/18.
//  Copyright © 2018 GIT SIT. All rights reserved.
//

import UIKit
import Charts

class GraphController: UIViewController {
    
    let dailyCount = 24
    let weeklyCount = 7

    @IBOutlet weak var lineChartView: LineChartView!
    @IBAction func randomize(_ sender: UIButton) {
        setChartValues(dailyCount)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.legend.enabled = false
        lineChartView.chartDescription?.text = ""
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        setUpChartHourly()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func dailyButton(_ sender: UIButton) {
        setUpChartHourly()
    }
    @IBAction func weeklyButton(_ sender: UIButton) {
        setUpChartWeekly()
    }
    
    // chart first loads will have 24 items in it
    func setChartValues(_ count: Int) {
        var values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Int(arc4random_uniform(24) + 15)
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        values.append(ChartDataEntry(x: 0, y: 50))
        
        let set1 = LineChartDataSet(values: values, label: "")
        let data = LineChartData(dataSet: set1)
        
        self.lineChartView.data = data
    }
    
    func setUpChartHourly() {
        var hours = [String()]
        for i in 1...24 {
            hours.append(String(i))
        }
        setChartValues(dailyCount)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: hours)
        lineChartView.xAxis.granularity = 1
        
        // refresh chart
        lineChartView.notifyDataSetChanged()
    }
    
    func setUpChartWeekly() {
        let months = ["4/17", "4/18", "4/19", "4/20", "4/21", "4/22", "4/23"]
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        lineChartView.xAxis.granularity = 1
        
        setChartValues(weeklyCount)
        
        // refresh chart
        lineChartView.notifyDataSetChanged()
    }
}

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}


extension ChartXAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
            let referenceTimeInterval = referenceTimeInterval
            else {
                return ""
        }
        
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
    
}
