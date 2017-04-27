//
//  AppDelegate.swift
//  DynamiCare
//
//  Created by Jordan Carney on 4/25/17.
//  Copyright © 2017 Jordan Carney. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        StyleManager.applyAppStyle()
        return true
    }
}

