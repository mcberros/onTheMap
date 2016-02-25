//
//  LocationsListViewController.swift
//  onTheMap
//
//  Created by Carmen Berros on 24/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController {
    var students: [StudentInformation] = [StudentInformation]()

    var appDelegate: AppDelegate!
    
    let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    let baseParseURL = "https://api.parse.com/"
    let getStudentLocationsMethod = "1/classes/StudentLocation"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        getLocationsList()
    }

    private func getLocationsList(){

        let parameters = [ "limit": 100,
                           "order": "-updatedAt"]

        let urlString = baseParseURL + getStudentLocationsMethod + ApisClient.escapedParameters(parameters)

        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)

            request.addValue(parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(restApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

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

                let students = StudentInformation.studentsFromResults(results)

                print(students)
            }
            task.resume()
        }


    }
}
