//
//  AnnotationPin.swift
//  GIT SIT
//
//  Created by Edwin on 2/26/18.
//  Copyright © 2018 GIT SIT. All rights reserved.
//

import MapKit
import AddressBook

class AnnotationPin: NSObject, MKAnnotation {
    
    var title: String?
    var address: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}
