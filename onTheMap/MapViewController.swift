//
//  MapViewController.swift
//  onTheMap
//
//  Created by Carmen Berros on 25/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var students: [StudentInformation]?
    var annotations: [MKPointAnnotation]?
    var appDelegate: AppDelegate!

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        students = appDelegate.students
        annotations = [MKPointAnnotation]()
        getLocationsList()
    }

    private func getLocationsList(){
        let parameters = [ "limit": 100,
            "order": "-updatedAt"]

        let urlString = ApisClient.Constants.BaseParseURL + ApisClient.Methods.GetStudentLocationsMethod + ApisClient.escapedParameters(parameters)

        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)

            request.addValue(ApisClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ApisClient.Constants.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard (error == nil) else {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Connection error")}
                    return
                }

                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Your request returned an invalid response")}
                    return
                }

                guard let data = data else {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "No data was returned by the request")}
                    return
                }


                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "The login response data could not be parsed")}
                    return
                }

                guard let results = parsedResult["results"] as? [[String: AnyObject]] else {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "No results for Students list")}
                    return
                }

                self.students = StudentInformation.studentsFromResults(results)
                self.appDelegate.students = self.students!

                self.getAnnotations()

                if let annotations = self.annotations {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.mapView.addAnnotations(annotations)
                    }
                }
            }
            task.resume()
        }
    }

    private func getAnnotations() {
        for student in self.students! {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let firstName = student.firstName
            let lastName = student.lastName
            let mediaURL = student.mediaURL

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL

            annotations!.append(annotation)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "Student"

        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}
