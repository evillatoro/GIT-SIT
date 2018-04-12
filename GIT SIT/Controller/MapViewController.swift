//
//  MapViewController.swift
//  GIT SIT
//
//  Created by Edwin on 2/25/18.
//  Copyright © 2018 GIT SIT. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(building: Building)
}


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var buildings:[Building]?
    var annotations: [AnnotationPin] = []
    var resultSearchController:UISearchController? = nil
    var selectedPin:Building? = nil
    var building_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.showsCompass = true
        
        // set initial location in Georgia Tech
        let initialLocation = CLLocation(latitude: 33.7756, longitude: -84.3963)
        zoomMapOn(location: initialLocation)
        
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
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
        
        // used for getting all the buildings
        //getBuildingsFromApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLocationServiceAuthenticationStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // amount that will zoom out
    let regionRadius: CLLocationDistance = 1500 // 1.5 km
    func zoomMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
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
                    for building in self.buildings! {
                        let buildingName = building.name!
                        let address = building.address!
                        let latitude = (building.latitude! as NSString).doubleValue
                        let longitude = (building.longitude! as NSString).doubleValue
                        let b_id = building.b_id!
                        let pin = AnnotationPin(title: buildingName, address: address,
                                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), b_id: b_id)
                        self.annotations.append(pin)
                    }
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr, "\n")
            }
            }.resume()
    }
    
    // MARK: - Current Location
    
    var locationManager = CLLocationManager()
    func checkLocationServiceAuthenticationStatus() {
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
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

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last!
        self.mapView.showsUserLocation = true
//        zoomMapOn(location: location)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? AnnotationPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
        
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? AnnotationPin {
            getBuildingInfoFromApi(b_id: annotation.b_id!)
        }
    }
    
    func getBuildingInfoFromApi(b_id: String) {
        building_id = b_id
        performSegue(withIdentifier: "toBuildingInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let listOfProductsViewController = segue.destination as! BuildingInfoController
        listOfProductsViewController.b_id = building_id
        listOfProductsViewController.building = [selectedPin] as! [Building]
    }

}


extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(building: Building){
        
        // cache the pin
        selectedPin = building
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let buildingName = building.name!
        let address = building.address!
        let latitude = (building.latitude! as NSString).doubleValue
        let longitude = (building.longitude! as NSString).doubleValue
        let b_id = building.b_id!
        
        resultSearchController?.searchBar.text = buildingName
        
        let pin = AnnotationPin(title: buildingName, address: address,
                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), b_id: b_id)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate,
                                                                  regionRadius / 4, regionRadius / 4)
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)
    }
}

























