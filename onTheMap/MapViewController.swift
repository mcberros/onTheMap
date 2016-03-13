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
        students = ParseApiClient.sharedInstance().students
        annotations = [MKPointAnnotation]()

        ParseApiClient.sharedInstance().getLocationsList(){ (success, errorString) in
            if success {
                self.students = ParseApiClient.sharedInstance().students
                self.refreshView()
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.appDelegate.showAlert(self, message: errorString!)
                }
            }
        }
    }

    func refreshView() {
        self.getAnnotations()

        if let annotations = self.annotations {
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotations(annotations)
            }
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
