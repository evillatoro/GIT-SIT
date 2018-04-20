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

    @IBOutlet weak var lineChartView: LineChartView!
    @IBAction func randomize(_ sender: UIButton) {
//        let count = Int(arc4random_uniform(20) + 3) // 0 - 20 + 3
        let count = 7
        setChartValues(count)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setChartValues()
        getDataFromApi()
        setUpChart()
        // Do any additional setup after loading the view.
    }
    
    // chart first loads will have 20 items in it
    func setChartValues(_ count: Int = 7) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Int(arc4random_uniform(24) + 30)
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        
//        values.append(ChartDataEntry()
        
        let set1 = LineChartDataSet(values: values, label: "")
        let data = LineChartData(dataSet: set1)
        
        self.lineChartView.data = data
    }
    
    func getDataFromApi() {
        let json: [String: Any] = ["location-id": "076",
                                   "floor": "1"]
        
        let url = URL(string: "https://git-sit.herokuapp.com/get-next-week-occupancy")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            let cool = responseString.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: cool, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print(jsonArray)
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
    
    func setUpChart() {
        let months = ["4/13", "4/14", "4/15", "4/16", "4/17", "4/18", "4/19"]
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        lineChartView.xAxis.granularity = 1
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
