//
//  TableViewController.swift
//  GIT SIT
//
//  Created by OrangeWorksMacTwo on 4/20/18.
//  Copyright © 2018 GIT SIT. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    var allBuildings = [Building]()
    
    var filteredBuildings = [Building]()
    var buildingSelected = Building()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
//        searchBar.returnKeyType = UIReturnKeyType.done
        
        getBuildingsFromApi()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBuildingsFromApi() {
        let jsonUrlString = "https://m.gatech.edu/api/gtplaces/buildings"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                
                // put try because .decode could throw a potential error
                self.allBuildings = try decoder.decode([Building].self, from: data)
                
                DispatchQueue.main.async {
                    // load the table view with all the buildings
                    self.tableView.reloadData()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr, "\n")
            }
            }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            
            self.filteredBuildings = [Building]()
            guard let searchBarText = searchBar.text else { return }
            
            for building in allBuildings {
                let buildingName = building.name
                
                if (buildingName?.lowercased().contains(searchBarText.lowercased()))! {
                    filteredBuildings.append(building)
                }
            }
            
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let buildingInfoController = segue.destination as! BuildingInfoController
        buildingInfoController.building = buildingSelected
    }
}

extension TableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredBuildings.count
        }
        return allBuildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellA")!
        
        if isSearching {
            cell.textLabel?.text = filteredBuildings[indexPath.row].name
            cell.detailTextLabel?.text = filteredBuildings[indexPath.row].address
        } else {
            cell.textLabel?.text = allBuildings[indexPath.row].name
            cell.detailTextLabel?.text = allBuildings[indexPath.row].address
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRow = indexPath.row
        
        if isSearching {
            buildingSelected = filteredBuildings[selectedRow]
        } else {
            buildingSelected = allBuildings[selectedRow]
        }
        
        performSegue(withIdentifier: "toBuildingInfo", sender: self)
    }
}
