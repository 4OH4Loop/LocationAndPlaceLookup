//
//  Place.swift
//  LocationAndPlaceLookup
//
//  Created by Carolyn Ballinger on 4/6/25.
//

import Foundation
import MapKit
import Contacts

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    // initialize a place from just coordinates
    init(Location: CLLocation) async {
        let geoCoder = CLGeocoder()
        do {
            guard let placemark = try await geoCoder.reverseGeocodeLocation(Location).first else {
                self.init(mapItem: MKMapItem())
                return
            }
            let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
            self.init(mapItem: mapItem)
        } catch {
            print("😡🌎 GEOCODING ERROR: \(error.localizedDescription)")
            self.init(mapItem: MKMapItem())
        }
    }
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: Double {
        self.mapItem.placemark.coordinate.self.longitude
    }
    
    var address: String {
        let postalAddress = mapItem.placemark.postalAddress ?? CNPostalAddress()
        // Get String that is a multiline formatted postal address
        var address = CNPostalAddressFormatter().string(from: postalAddress)
        // Remove line feeds from multiline String above
        address = address.replacingOccurrences(of: "\n", with: ", ")
        
        return address
    }
}
