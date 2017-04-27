//
//  GeocodingService.swift
//  DynamiCare
//
//  Created by Jordan Carney on 4/26/17.
//  Copyright © 2017 Jordan Carney. All rights reserved.
//

import UIKit
import CoreLocation

protocol GeocodingServiceDelegate: class {
    func didReverseGeocodeWithResult(_ location: Location?, error: Error?)
    func didGeocodeWithResult(_ location: Location?, error: Error?)
}

class GeocodingService {
    
    private struct Attributes {
        static let ApiKey = "AIzaSyBARFwxINxdnY4pBzT4oiAyBf6TCAq6MO0"
    }
    
    var delegate: GeocodingServiceDelegate?
    
    func reverseGeocode(location: CLLocation) {
        let coordinate = location.coordinate
        let queryItem = URLQueryItem(name: "latlng", value: "\(coordinate.latitude),\(coordinate.longitude)")
        getLocationMatchingQueryItem(queryItem) { [weak self] location, error in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didReverseGeocodeWithResult(location, error: error)
        }
    }
    
    func geocode(location: String) {
        let queryItem = URLQueryItem(name: "address", value: location)
        getLocationMatchingQueryItem(queryItem) { [weak self] location, error in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didGeocodeWithResult(location, error: error)
        }
    }
    
    private func getLocationMatchingQueryItem(_ queryItem: URLQueryItem, completion: @escaping (Location?, Error?) -> ()) {
        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")!
        components.queryItems = [
            queryItem,
            URLQueryItem(name: "key", value: Attributes.ApiKey)
        ]
        
        let session = URLSession.shared
        let task = session.dataTask(with: components.url!) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                let results = json?["results"] as? [[String:Any]],
                let firstMatch = results.first,
                let address = firstMatch["formatted_address"] as? String,
                let coords = (firstMatch["geometry"] as? [String:Any])?["location"] as? [String:Any]
                else {
                    completion(nil, error)
                    return
            }
            
            let coordinate = CLLocationCoordinate2D(
                latitude: coords["lat"] as! Double,
                longitude: coords["lng"] as! Double
            )
            let result = Location(name: address, coords: coordinate)
            completion(result, nil)
        }
        task.resume()
    }
}
