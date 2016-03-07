//
//  UdacityApiConvenience.swift
//  onTheMap
//
//  Created by Carmen Berros on 06/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//
import UIKit
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


//    func logout() {
//        let urlString = ApisClient.Constants.BaseUdacityURL + ApisClient.Methods.SessionMethod
//        if let url = NSURL(string: urlString) {
//            let request = NSMutableURLRequest(URL: url)
//
//            request.HTTPMethod = "DELETE"
//
//            var xsrfCookie: NSHTTPCookie? = nil
//            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//            for cookie in sharedCookieStorage.cookies! {
//                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//            }
//
//            if let xsrfCookie = xsrfCookie {
//                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//            }
//
//            let session = NSURLSession.sharedSession()
//            let task = session.dataTaskWithRequest(request) { data, response, error in
//                guard (error == nil) else{
//                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Connection error")}
//                    return
//                }
//
//                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Your request returned an invalid response")}
//                    return
//                }
//
//                guard let data = data else {
//                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "No data was returned by the request")}
//                    return
//                }
//
//                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
//
//                let parsedResult: AnyObject!
//                do {
//                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
//                } catch {
//                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "The logout response data could not be parsed")}
//                    return
//                }
//
//                guard let _ = parsedResult["session"]!!["id"] as? String else{
//                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "There was an error in the parsed data for the logout")}
//                    return
//                }
//
//                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
//                
//                self.completeLogout()
//            }
//            task.resume()
//            
//        }
}