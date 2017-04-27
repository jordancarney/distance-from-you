//
//  StyleManager.swift
//  DynamiCare
//
//  Created by Jordan Carney on 4/26/17.
//  Copyright © 2017 Jordan Carney. All rights reserved.
//

import UIKit
import MapKit

class StyleManager {
    
    private struct Attributes {
        static let NavigationBarFontSize: CGFloat = 18.0
    }
    
    static func titleFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize:size)
    }
    
    static func bodyFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize:size)
    }
    
    static func applyAppStyle() {
        applyNavigationBarStyle()
        applyTextFieldStyle()
        applyMapStyle()
    }
    
    private static func applyNavigationBarStyle() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName : titleFont(ofSize: Attributes.NavigationBarFontSize),
            NSForegroundColorAttributeName: UIColor.white
        ]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.appGreen
        UINavigationBar.appearance().barTintColor = UIColor.appBlue
    }
    
    private static func applyTextFieldStyle() {
        UITextField.appearance().tintColor = UIColor.appGreen
    }
    
    private static func applyMapStyle() {
        MKPinAnnotationView.appearance().tintColor = UIColor.appGreen
        MKPinAnnotationView.appearance().pinTintColor = UIColor.appGreen
    }
}
