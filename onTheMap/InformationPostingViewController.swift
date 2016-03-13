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

    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var whereTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var appDelegate: AppDelegate!
    var mapString: String?
    var coordinate: CLLocationCoordinate2D?
    var latitude: Double?
    var longitude: Double?

    var tapRecognizer: UITapGestureRecognizer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        prepareUIForFirstStep()

        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1

        whereTextField.delegate = self
        mediaURLTextField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.addKeyboardDismissRecognizer()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.removeKeyboardDismissRecognizer()
    }

    @IBAction func findOnTheMapButtonTouch(sender: AnyObject) {
        if whereTextField.text!.isEmpty {
            appDelegate.showAlert(self, message: "Empty Location")
        } else {
            forwardGeocoding(whereTextField.text!)
        }
    }

    @IBAction func submitButtonTouch(sender: AnyObject) {
        if mediaURLTextField.text!.isEmpty {
            appDelegate.showAlert(self, message: "The URL is empty")
        } else {
            ParseApiClient.sharedInstance().postStudentInformation(mediaURLTextField.text!, latitude: latitude!, longitude: longitude!, mapString: mapString!) { (success, errorString) in
                if success {
                    dispatch_async(dispatch_get_main_queue()){
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()){
                        self.appDelegate.showAlert(self, message: errorString!)
                    }
                }
            }
        }
    }

    @IBAction func cancelButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func prepareUIForFirstStep() {
        whereLabel.hidden = false
        whereTextField.hidden = false
        findOnTheMapButton.hidden = false

        mediaURLTextField.hidden = true
        mapView.hidden = true
        submitButton.hidden = true
    }

    private func prepareUIForSecondtStep() {
        whereLabel.hidden = true
        whereTextField.hidden = true
        findOnTheMapButton.hidden = true

        mediaURLTextField.hidden = false
        mapView.hidden = false
        submitButton.hidden = false
    }

    private func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in

            dispatch_async(dispatch_get_main_queue()){
                self.activityIndicator.startAnimating()
            }

            guard error == nil else {
                dispatch_async(dispatch_get_main_queue()){
                    self.appDelegate.showAlert(self, message: "Geocoding failed")
                    self.activityIndicator.stopAnimating()
                }
                return
            }

            guard (placemarks?.count > 0) else {
                dispatch_async(dispatch_get_main_queue()){
                    self.appDelegate.showAlert(self, message: "No placemarks found")
                    self.activityIndicator.stopAnimating()
                }
                return
            }

            dispatch_async(dispatch_get_main_queue()){
                self.activityIndicator.stopAnimating()
            }

            let placemark = placemarks?[0]
            let location = placemark?.location
            self.coordinate = location?.coordinate
            self.mapString = self.whereTextField!.text
            self.latitude = self.coordinate!.latitude
            self.longitude = self.coordinate!.longitude
            self.nextStep()

        }
    }

    private func nextStep(){
        guard let _ = self.longitude else {
            dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "There are no coordinates for this place")}
            return
        }

        let pointAnnotation:MKPointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate!
        mapView?.addAnnotation(pointAnnotation)
        mapView?.centerCoordinate = coordinate!

        prepareUIForSecondtStep()

    }

//    private func postStudentInformation(){
//        let urlString = ParseApiClient.Constants.BaseParseURL + ParseApiClient.Methods.GetStudentLocationsMethod
//        let url = NSURL(string: urlString)
//        let request = NSMutableURLRequest(URL: url!)
//        request.HTTPMethod = "POST"
//        request.addValue(ParseApiClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue(ParseApiClient.Constants.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let uniqueKey = UdacityApiClient.sharedInstance().userID!
//        let firstName = UdacityApiClient.sharedInstance().firstName!
//        let lastName = UdacityApiClient.sharedInstance().lastName!
//        let mediaURL = mediaURLTextField.text!
//
//        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude!), \"longitude\": \(longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
//
//
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            guard error == nil else {
//                dispatch_async(dispatch_get_main_queue()){
//                    self.appDelegate.showAlert(self, message: "Connection error")
//                }
//                return
//            }
//
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                print((response as? NSHTTPURLResponse)?.statusCode)
//                dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Your request returned an invalid response")}
//                return
//            }
//
//            guard let data = data else {
//                dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "No data was returned by the request")}
//                return
//            }
//
//            let parsedResult: AnyObject
//
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            } catch {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.appDelegate.showAlert(self, message: "The data could not be parsed")
//                }
//                return
//            }
//
//            dispatch_async(dispatch_get_main_queue()){
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//        }
//        task.resume()
//    }
}

extension InformationPostingViewController {

    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }

    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }

    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

extension InformationPostingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

}
