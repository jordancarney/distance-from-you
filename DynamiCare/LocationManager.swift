//
//  LocationManager.swift
//  DynamiCare
//
//  Created by Jordan Carney on 4/26/17.
//  Copyright © 2017 Jordan Carney. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationRequestCompletion = (_ location: Location?, _ error: Error?) -> ()
typealias LocationAccessRequestCompletion = (_ newStatus: CLAuthorizationStatus) -> ()

class LocationManager: NSObject, CLLocationManagerDelegate, GeocodingServiceDelegate {
    
    private let geocodingService = GeocodingService()
    private var locationManager = CLLocationManager()
    private var locationRequestCompletionHandler: LocationRequestCompletion?
    private var locationSearchCompletionHandler: LocationRequestCompletion?
    private var locationAccessRequestCompletionHandler: LocationAccessRequestCompletion?
    
    override init() {
        super.init()
        commonInit()
    }
    
    private func commonInit() {
        geocodingService.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func getCurrentLocation(completionHandler: @escaping LocationRequestCompletion) {
        locationRequestCompletionHandler = completionHandler
        locationManager.requestLocation()
    }
    
    func getLocationFromString(_ locationString: String, completionHandler: @escaping LocationRequestCompletion) {
        locationSearchCompletionHandler = completionHandler
        geocodingService.geocode(location: locationString)
    }
    
    func requestWhenInUseAccess(completionHandler: @escaping LocationAccessRequestCompletion) {
        locationAccessRequestCompletionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
    }
    
    class func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    // MARK: GeocodingServiceDelegate
    
    func didReverseGeocodeWithResult(_ location: Location?, error: Error?) {
        DispatchQueue.main.async {
            self.locationRequestCompletionHandler?(location, error)
            self.locationRequestCompletionHandler = nil
        }
    }
    
    func didGeocodeWithResult(_ location: Location?, error: Error?) {
        DispatchQueue.main.async {
            self.locationSearchCompletionHandler?(location, error)
            self.locationSearchCompletionHandler = nil
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationAccessRequestCompletionHandler?(status)
            self.locationAccessRequestCompletionHandler = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocodingService.reverseGeocode(location: location)
        } else {
            didFailLocationRequest(withError: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailLocationRequest(withError: error)
    }
    
    private func didFailLocationRequest(withError error: Error?) {
        DispatchQueue.main.async {
            self.locationRequestCompletionHandler?(nil, error)
            self.locationRequestCompletionHandler = nil
        }
    }
}
