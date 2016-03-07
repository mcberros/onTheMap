//
//  UdacityApiConvenience.swift
//  onTheMap
//
//  Created by Carmen Berros on 06/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//
import Foundation

extension UdacityApiClient {

    func getSession(user: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let urlString = UdacityApiClient.Constants.BaseUdacityURL + UdacityApiClient.Methods.SessionMethod

        let jsonBody: [String: AnyObject] = [
            "udacity": ["username": user, "password": password]]

        taskForPOSTMethod(urlString, jsonBody: jsonBody) {(success, result, errorString) in
            if success {
                if let userID = result["account"]!!["key"] as? String {
                    self.userID = userID
                    print(self.userID)
                    self.getDataAuthUser(){(sucsess, errorString) in
                        if success {
                            completionHandler(success: true, errorString: errorString)
                        } else {
                            completionHandler(success: false, errorString: errorString)
                        }
                    }
                } else {
                    completionHandler(success: false, errorString: "No userID")
                }
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        }
    }

    func getDataAuthUser(completionHandler: (success: Bool, errorString: String?) -> Void) {
        var mutableMethod: String = UdacityApiClient.Methods.GetStudentInfo

        if let userId = self.userID {
            mutableMethod = UdacityApiClient.substituteKeyInMethod(mutableMethod, key: UdacityApiClient.URLSKeys.UserId, value: userId)!

            let urlString = UdacityApiClient.Constants.BaseUdacityURL + mutableMethod

            taskForGETMethod(urlString) { (success, result, errorString) -> Void in

                if success {
                    if let firstName = result["user"]!!["first_name"] as? String {
                        self.firstName = firstName
                    }

                    if let lastName = result["user"]!!["last_name"] as? String {
                        self.lastName = lastName
                    }

                    completionHandler(success: true, errorString: "")
                } else {
                    completionHandler(success: false, errorString: errorString)
                }
            }
        }
    }


    func logout(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let urlString = UdacityApiClient.Constants.BaseUdacityURL + UdacityApiClient.Methods.SessionMethod

        taskForDELETEMethod(urlString){ (success, result, errorString) in
            if success {
                guard let _ = result["session"]!!["id"] as? String else {
                    completionHandler(success: false, errorString: "There was an error in the parsed data for the logout")
                    return
                }
                completionHandler(success: true, errorString: "")
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        }
    }
}