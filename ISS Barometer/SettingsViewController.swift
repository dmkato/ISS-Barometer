//
//  SettingsViewController.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/7/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    var settings:Settings?
    lazy var settingsTableView = childViewControllers[0] as! SettingsTableViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsTableView.settings = self.settings
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        let orientationPickerSegments = ["Up": 0, "Down": 1, "Left": 2, "Right": 3]
        return UIInterfaceOrientation(rawValue: orientationPickerSegments[settings!.orientation]!)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}












