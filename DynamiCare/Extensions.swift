//
//  Extensions.swift
//  DynamiCare
//
//  Created by Jordan Carney on 4/26/17.
//  Copyright © 2017 Jordan Carney. All rights reserved.
//

import UIKit
import MapKit

extension UIColor {
    class var appGreen: UIColor {
        return UIColor(
            red: 82.0/255.0,
            green: 188.0/255.0,
            blue: 127.0/255.0,
            alpha: 1.0
        )
    }
    
    class var appBlue: UIColor {
        return UIColor(
            red: 51.0/255.0,
            green: 72.0/255.0,
            blue: 92.0/255.0,
            alpha: 1.0
        )
    }
}

extension UIApplication {
    func goToSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            open(url, options: [:], completionHandler: nil)
        }
    }
}


extension MKMapView {
    
    private struct Properties {
        static let MinimumMapSize: Double = 1000000
    }
    
    func fitToAnnotationsWithEdgePadding(_ padding: CGFloat, animated: Bool) {
        var zoomRect = MKMapRectNull
        for annotation in annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if MKMapRectIsNull(zoomRect) {
                let minSize = Properties.MinimumMapSize
                zoomRect = MKMapRectMake(annotationPoint.x - (minSize/2), annotationPoint.y - (minSize/2), minSize, minSize)
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(padding, padding, padding, padding), animated: animated)
    }
    
    func clearAnnotations() {
        self.removeAnnotations(self.annotations)
    }
}
