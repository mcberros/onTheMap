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
            ParseApiClient.ParameterKeys.Order: "-updatedAt"]

        let urlString = ParseApiClient.Constants.BaseParseURL + ParseApiClient.Methods.GetStudentLocationsMethod + ParseApiClient.escapedParameters(parameters)

        taskForGETMethod(urlString) { (success, result, errorString) -> Void in
            if success {
                guard let results = result["results"] as? [[String: AnyObject]] else {
                    completionHandler(success: false, errorString: "No results for Students list")
                    return
                }

                self.appDelegate.students = StudentInformation.studentsFromResults(results)
                completionHandler(success: true, errorString: "")
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        }
    }

}
