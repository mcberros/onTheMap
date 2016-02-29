//
//  InformationPostingViewController.swift
//  onTheMap
//
//  Created by Carmen Berros on 28/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var whereTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var firstStepView: UIView!
    @IBOutlet weak var secondStepView: UIView!

    var appDelegate: AppDelegate!
    var mapString: String?
    var latitude: Double?
    var longitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    @IBAction func findOnTheMapButtonTouch(sender: AnyObject) {
        if whereTextField.text!.isEmpty {
            appDelegate.showAlert(self, message: "Empty Location")
        } else {
            forwardGeocoding(whereTextField.text!)
        }
    }

    @IBAction func submitButtonTouch(sender: AnyObject) {
    }

    @IBAction func cancelButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            guard error == nil else {
                self.appDelegate.showAlert(self, message: "Geocoding failed")
                return
            }

            guard (placemarks?.count > 0) else {
                self.appDelegate.showAlert(self, message: "No placemarks found")
                return
            }

            let placemark = placemarks?[0]
            let location = placemark?.location
            let coordinate = location?.coordinate
            self.mapString = self.whereTextField!.text
            self.latitude = coordinate!.latitude
            self.longitude = coordinate!.longitude

            self.nextStep()

        }
    }

    private func nextStep(){
        guard let _ = self.longitude else {
            dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "There are no coordinates for this place")}
            return
        }

        firstStepView.hidden = true
        secondStepView.hidden = false


    }
}
