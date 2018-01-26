//
//  LockedNavigationViewController.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/29/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    var rotated = false
    var prevOrientation: String!
    lazy var settings: Settings = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.settings
    }()
    
    override var shouldAutorotate: Bool {
        if settings.orientation != prevOrientation {
            prevOrientation = settings.orientation
            return true
        } else {
            return false
        }
    }
}
