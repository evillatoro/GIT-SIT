//
//  LocationSearchTable.swift
//  GIT SIT
//
//  Created by Edwin on 2/26/18.
//  Copyright © 2018 GIT SIT. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController, UISearchResultsUpdating {
    
    
    var allBuildings = [Building]()
    var filteredBuildings = [Building]()
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    override func viewDidLoad() {
        getBuildingsFromApi()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredBuildings = [Building]()
        guard let searchBarText = searchController.searchBar.text else { return }
        
        print(searchBarText)
        
        for building in allBuildings {
            let buildingName = building.name
            
            if (buildingName?.lowercased().contains(searchBarText.lowercased()))! {
                filteredBuildings.append(building)
            }
        }
        self.tableView.reloadData()
    }
    
    func getBuildingsFromApi() {
        let jsonUrlString = "https://m.gatech.edu/api/gtplaces/buildings"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                self.allBuildings = [Building]()
                
                let decoder = JSONDecoder()
                
                // put try because .decode could throw a potential error
                self.allBuildings = try decoder.decode([Building].self, from: data)
                self.filteredBuildings = self.allBuildings
                
                DispatchQueue.main.async {
                    // load the table view with all the buildings
                    self.tableView.reloadData()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr, "\n")
            }
            }.resume()
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBuildings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = filteredBuildings[indexPath.row]
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.address
        return cell
    }
}

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filteredBuildings[indexPath.row]
        handleMapSearchDelegate?.dropPinZoomIn(building: selectedItem)
        
        dismiss(animated: true, completion: nil)
    }
}
