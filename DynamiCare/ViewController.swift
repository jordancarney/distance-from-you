//
//  ViewController.swift
//  DynamiCare
//
//  Created by Jordan Carney on 4/25/17.
//  Copyright © 2017 Jordan Carney. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: SearchTextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private let locationManager = LocationManager()
    
    private var location = Location(
        name: "Cambridge, MA",
        coords: CLLocationCoordinate2D(latitude: 42.3736, longitude: -71.1097)) {
        didSet {
            userLocationDidUpdate()
        }
    }
    
    private var destination: Location? {
        didSet {
            self.searchTextField.text = destination?.name
            locationsDidUpdated()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userLocationDidUpdate()
    }
    
    private func userLocationDidUpdate() {
        self.title = location.name
        locationsDidUpdated()
    }
    
    private func locationsDidUpdated() {
        mapView.clearAnnotations()
        
        mapView.addAnnotation(annotationFromCoordinate(location.coords))
        
        if let destination = destination {
            mapView.addAnnotation(annotationFromCoordinate(destination.coords))
            
            let meters = MKMetersBetweenMapPoints(
                MKMapPointForCoordinate(location.coords),
                MKMapPointForCoordinate(destination.coords)
            )
            distanceLabel.text = String(format: "Distance: %.1fmi", meters/1609.344)
        } else {
            distanceLabel.text = NSLocalizedString("Distance: ?", comment: "")
        }
        
        self.mapView.fitToAnnotationsWithEdgePadding(75.0, animated: true)
    }
    
    private func annotationFromCoordinate(_ coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
    
    private func getCurrentLocation() {
        locationManager.getCurrentLocation { [weak self] location, error in
            guard let strongSelf = self, let location = location else { return }
            strongSelf.location = location
        }
    }
    
    private func getDestinationFromString(_ locationString: String?) {
        guard let locationString = locationString, locationString.characters.count > 0 else {
            return
        }
        
        startLoadingDestination(true)
        locationManager.getLocationFromString(locationString) { [weak self] location, error in
            guard let strongSelf = self else { return }
            strongSelf.startLoadingDestination(false)
            strongSelf.destination = location
        }
    }
    
    private func startLoadingDestination(_ start: Bool) {
        searchTextField.isUserInteractionEnabled = !start
        if start {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: IBActions
    
    @IBAction func didPressCurrentLocation(_ sender: Any) {
        switch LocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            getCurrentLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAccess { [weak self] newStatus in
                guard let strongSelf = self else { return }
                switch newStatus {
                case .authorizedAlways, .authorizedWhenInUse:
                    strongSelf.getCurrentLocation()
                default:
                    print("Error: Failed to grant location access")
                }
            }
        case .denied:
            UIApplication.shared.goToSettings()
        case .restricted:
            print("You should handle restricted status in a proper application")
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getDestinationFromString(textField.text)
        return false
    }

}

