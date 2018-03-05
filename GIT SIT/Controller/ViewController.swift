//
//  ViewController.swift
//  GIT SIT
//
//  Created by OrangeWorksMacTwo on 2/25/18.
//  Copyright © 2018 GIT SIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tabelView: UITableView!
    
    var resultSearchController:UISearchController? = nil
    
    var buildings:[Building]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabelView.delegate = self
        tabelView.dataSource = self
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        getBuildingsFromApi()
        
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
                // put try because .decode could throw a potential error
                self.buildings = [Building]()
                
                let decoder = JSONDecoder()
                
                self.buildings = try decoder.decode([Building].self, from: data)
                
                DispatchQueue.main.async {
                    self.tabelView.reloadData()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr, "\n")
            }
            }.resume()
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        cell.textLabel?.text = buildings?[indexPath.row].name
        return cell
    }
}

