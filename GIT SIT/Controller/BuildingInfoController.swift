//
//  BuildingInfoController.swift
//  GIT SIT
//
//  Created by OrangeWorksMacTwo on 3/28/18.
//  Copyright © 2018 GIT SIT. All rights reserved.
//

import UIKit
import Charts

class BuildingInfoController: UIViewController {
    
    var test = LineChartData()
    
    @IBOutlet weak var floor1: UILabel!
    @IBOutlet weak var floor2: UILabel!
    @IBOutlet weak var floor3: UILabel!
    @IBOutlet weak var floor4: UILabel!
    @IBOutlet weak var floor5: UILabel!
    @IBOutlet weak var building_name: UILabel!
    @IBOutlet weak var building_address: UILabel!
    var b_id = String()
    var building = Building()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(building[0].name!)
        building_name.text = building.name!
        building_address.text = building.address!
//        getbuildingOccupancyFromAPiFloor1(b_id: b_id)
//        getbuildingOccupancyFromAPiFloor2(b_id: b_id)
//        getbuildingOccupancyFromAPiFloor3(b_id: b_id)
//        getbuildingOccupancyFromAPiFloor4(b_id: b_id)
//        getbuildingOccupancyFromAPiFloor5(b_id: b_id)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getBuildingInfoFromApi(b_id: String) {
//        print(b_id)
//                let jsonUrlString = "https://m.gatech.edu/api/gtplaces/buildings_id/\(b_id)"
//                guard let url = URL(string: jsonUrlString) else { return }
//
//                URLSession.shared.dataTask(with: url) { (data, response, err) in
//                    guard let data = data else { return }
//
//                    do {
//
//                        let decoder = JSONDecoder()
//
//                        // put try because .decode could throw a potential error
//                        self.building = try decoder.decode([Building].self, from: data)
//
//                        DispatchQueue.main.async {
//                            print(self.building[0].name)
//                        }
//                    } catch let jsonErr {
//                        print("Error serializing json:", jsonErr, "\n")
//                    }
//                    }.resume()
//    }
    
    func getbuildingOccupancyFromAPiFloor1(b_id: String) {
        let json: [String: Any] = ["location-id": b_id,
                                   "floor": "1"]
//        let json: [String: Any] = ["location-id": b_id,
//                                   "datetime": "2015-01-09 22:54:37",
//                                   "floor": "2"]
        
        let url = URL(string: "https://git-sit.herokuapp.com/get-current-occupancy")!
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
                print("response = \(response)")
                
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if let occupancy = Int(responseString!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print(occupancy);
                DispatchQueue.main.async {
                    self.floor1.text = String(occupancy) + "/50"
                }
            }
        }
        task.resume()
    }
    
    func getbuildingOccupancyFromAPiFloor2(b_id: String) {
        let json: [String: Any] = ["location-id": b_id,
                                   "floor": "2"]
        //        let json: [String: Any] = ["location-id": b_id,
        //                                   "datetime": "2015-01-09 22:54:37",
        //                                   "floor": "2"]
        
        let url = URL(string: "https://git-sit.herokuapp.com/get-current-occupancy")!
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
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if let occupancy = Int(responseString!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print(occupancy);
                DispatchQueue.main.async {
                    self.floor2.text = String(occupancy) + "/250"
                }
            }
        }
        task.resume()
    }
    func getbuildingOccupancyFromAPiFloor3(b_id: String) {
        let json: [String: Any] = ["location-id": b_id,
                                   "floor": "3"]
        //        let json: [String: Any] = ["location-id": b_id,
        //                                   "datetime": "2015-01-09 22:54:37",
        //                                   "floor": "2"]
        
        let url = URL(string: "https://git-sit.herokuapp.com/get-current-occupancy")!
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
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if let occupancy = Int(responseString!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print(occupancy);
                DispatchQueue.main.async {
                    self.floor3.text = String(occupancy) + "/200"
                }
            }
        }
        task.resume()
    }
    func getbuildingOccupancyFromAPiFloor4(b_id: String) {
        let json: [String: Any] = ["location-id": b_id,
                                   "floor": "4"]
        //        let json: [String: Any] = ["location-id": b_id,
        //                                   "datetime": "2015-01-09 22:54:37",
        //                                   "floor": "2"]
        
        let url = URL(string: "https://git-sit.herokuapp.com/get-current-occupancy")!
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
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if let occupancy = Int(responseString!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print(occupancy);
                DispatchQueue.main.async {
                    self.floor4.text = String(occupancy) + "/160"
                }
            }
        }
        task.resume()
    }
    func getbuildingOccupancyFromAPiFloor5(b_id: String) {
        let json: [String: Any] = ["location-id": b_id,
                                   "floor": "5"]
        //        let json: [String: Any] = ["location-id": b_id,
        //                                   "datetime": "2015-01-09 22:54:37",
        //                                   "floor": "2"]
        
        let url = URL(string: "https://git-sit.herokuapp.com/get-current-occupancy")!
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
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if let occupancy = Int(responseString!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                print(occupancy);
                DispatchQueue.main.async {
                    self.floor5.text = String(occupancy) + "/75"
                }
            }
        }
        task.resume()
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
