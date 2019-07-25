//
//  Mapas.swift
//  RonchStore
//
//  Created by Roberto Loaeza Valerio on 7/25/19.
//  Copyright © 2019 Roberto Loaeza Valerio. All rights reserved.
//

import MapKit
import Contacts


class Mapas: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let latitudinalMeters: CLLocationDistance = 1000
    let longitudinalMeters: CLLocationDistance = 1000
    
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }

}
