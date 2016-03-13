//
//  ParseApiConvenience.swift
//  onTheMap
//
//  Created by Carmen Berros on 07/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import Foundation

extension ParseApiClient {

    func getLocationsList(completionHandler: (success: Bool, errorString: String?) -> Void){

        let parameters = [ ParseApiClient.ParameterKeys.Limit: 100,
            ParseApiClient.ParameterKeys.Order: ParseApiClient.ParameterValues.AscendingUpdatedAt]

        let urlString = ParseApiClient.Constants.BaseParseURL + ParseApiClient.Methods.GetStudentLocationsMethod + ParseApiClient.escapedParameters(parameters as! [String : AnyObject])

        taskForGETMethod(urlString) { (success, result, errorString) -> Void in
            if success {
                guard let results = result["results"] as? [[String: AnyObject]] else {
                    completionHandler(success: false, errorString: "No results for Students list")
                    return
                }

                self.students = StudentInformation.studentsFromResults(results)
                completionHandler(success: true, errorString: "")
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        }
    }

    func postStudentInformation(mediaURL: String, latitude: Double, longitude: Double, mapString: String, completionHandler: (success: Bool, errorString: String?) -> Void) {

        let urlString = ParseApiClient.Constants.BaseParseURL + ParseApiClient.Methods.GetStudentLocationsMethod

        let uniqueKey = UdacityApiClient.sharedInstance().userID!
        let firstName = UdacityApiClient.sharedInstance().firstName!
        let lastName = UdacityApiClient.sharedInstance().lastName!

        let jsonBody: [String: AnyObject] = ["uniqueKey": uniqueKey, "firstName": firstName,
            "lastName": lastName,
            "mapString": mapString,
            "mediaURL": mediaURL,
            "latitude": latitude,
            "longitude": longitude]

        taskForPOSTMethod(urlString, jsonBody: jsonBody) {
            (success, result, errorString) in
            if success {
                if let _ = result["objectID"] as? String {
                    completionHandler(success: true, errorString: errorString)
                } else {
                    completionHandler(success: true, errorString: "No valid response form post student")
                }
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        }
    }
}
