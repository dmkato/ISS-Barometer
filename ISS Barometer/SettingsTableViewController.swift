//
//  SettingsTableViewController.swift
//  ISS Barometer
//
//  Created by Daniel Kato on 12/29/17.
//  Copyright © 2017 ISSBarometer. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var settings:Settings?

    @IBOutlet weak var sigFigSlider: UISlider!
    @IBOutlet weak var sigFigValue: UILabel!
    @IBOutlet weak var unitPicker: UISegmentedControl!
    @IBOutlet weak var orientationPicker: UISegmentedControl!
    
    @IBAction func sliderMoved(_ sender: Any) {
        let roundedValue = lroundf(sigFigSlider.value)
        (sender as AnyObject).setValue(Float(roundedValue), animated: true)
        sigFigValue.text = String(roundedValue)
        settings?.sigFigs = roundedValue
    }
    
    @IBAction func unitPicked(_ sender: Any) {
        let selectedIdx = unitPicker.selectedSegmentIndex
        let selectedUnit = unitPicker.titleForSegment(at: selectedIdx)
        settings?.units = selectedUnit!
    }
    
    @IBAction func orientationPicked(_ sender: Any) {
        let selectedIdx = orientationPicker.selectedSegmentIndex
        let selectedOrientation = orientationPicker.titleForSegment(at: selectedIdx)
        settings?.orientation = selectedOrientation!
    }
    
    func initSlider() {
        sigFigValue.text = String(describing: settings!.sigFigs)
        sigFigSlider.setValue(Float(settings!.sigFigs), animated: true)
    }
    
    func initUnitPicker() {
        let unitPickerSegments = ["mmHg": 0, "psi": 1, "kPa": 2, "atm": 3]
        let segmentIdx = unitPickerSegments[settings!.units]!
        unitPicker.selectedSegmentIndex = segmentIdx
    }
    
    func initOrientationPicker() {
        let orientationPickerSegments = ["Up": 0, "Down": 1, "Left": 2, "Right": 3]
        let segmentIdx = orientationPickerSegments[settings!.orientation]!
        orientationPicker.selectedSegmentIndex = segmentIdx
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initSlider()
        initUnitPicker()
        initOrientationPicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


