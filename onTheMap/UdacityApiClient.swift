//
//  UdacityApiClient.swift
//  onTheMap
//
//  Created by Carmen Berros on 25/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import Foundation

class UdacityApiClient : NSObject {

    var session: NSURLSession

    var userID: String? = nil
    var firstName: String?
    var lastName: String?

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    func taskForPOSTMethod(urlString: String, jsonBody: [String: AnyObject], completionHandler: (success: Bool, result: AnyObject!, errorString: String) -> Void) {

        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)

            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            }

            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard (error == nil) else {
                    completionHandler(success: false, result: nil, errorString: "Connection error")
                    return
                }

                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    if (response as? NSHTTPURLResponse)?.statusCode == 403 {
                        completionHandler(success: false, result: nil, errorString: "Invalid email or password")
                    } else {
                        completionHandler(success: false, result: nil, errorString: "Your request returned an invalid response")
                    }
                    return
                }

                guard let data = data else {
                    completionHandler(success: false, result: nil, errorString: "No data was returned by the request")
                    return
                }

                let newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))

                UdacityApiClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)

            }
            task.resume()
        }
    }

    func taskForGETMethod(urlString: String, completionHandler: (success: Bool, result: AnyObject!, errorString: String) -> Void) {
        let url = NSURL(string: urlString)

        if let url = url {
            let request = NSMutableURLRequest(URL: url)

            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard error == nil else {
                    completionHandler(success: false, result: nil, errorString: "Connection error")
                    return
                }

                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    completionHandler(success: false, result: nil, errorString: "Your request returned an invalid response")
                    return
                }

                guard let data = data else {
                    completionHandler(success: false, result: nil, errorString: "No data was returned by the request")
                    return
                }

                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */

                UdacityApiClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)

            }
            task.resume()
        }

    }

    func taskForDELETEMethod(urlString: String, completionHandler: (success: Bool, result: AnyObject!, errorString: String) -> Void){

        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)

            request.HTTPMethod = "DELETE"

            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }

            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }

            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard (error == nil) else{
                    completionHandler(success: false, result: nil, errorString: "Connection error")
                    return
                }

                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    completionHandler(success: false, result: nil, errorString: "Your request returned an invalid response")
                    return
                }

                guard let data = data else {
                    completionHandler(success: false, result: nil, errorString: "No data was returned by the request")
                    return
                }

                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

                UdacityApiClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)

            }
            task.resume()
            
        }
    }

    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (success: Bool, result: AnyObject!, error: String) -> Void){

        var parsedResult: AnyObject!

        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(success: false, result: nil, error: "The response data could not be parsed")
            return
        }

        completionHandler(success: true, result: parsedResult, error: "")
    }

    class func sharedInstance() -> UdacityApiClient {
        struct Singleton {
            static var sharedInstance = UdacityApiClient()
        }
        return Singleton.sharedInstance
    }

    class func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
}