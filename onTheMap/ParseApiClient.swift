//
//  ParseApiClient.swift
//  onTheMap
//
//  Created by Carmen Berros on 07/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit
import Foundation

class ParseApiClient: NSObject {
    var session: NSURLSession
    var students: [StudentInformation] = [StudentInformation]()

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    func taskForGETMethod(urlString: String, completionHandler: (success: Bool, result: AnyObject!, errorString: String) -> Void) {

        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)

            request.addValue(ParseApiClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParseApiClient.Constants.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard (error == nil) else {
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

                ParseApiClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                
            }
            task.resume()
        }

    }

    func taskForPOSTMethod(urlString: String, jsonBody: [String: AnyObject], completionHandler: (success: Bool, result: AnyObject!, errorString: String) -> Void){

        if let url = NSURL(string: urlString) {

            let request = NSMutableURLRequest(URL: url)

            request.HTTPMethod = "POST"
            request.addValue(ParseApiClient.Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParseApiClient.Constants.RestApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            }

            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard error == nil else {
                    completionHandler(success: false, result: nil, errorString: "Connection error")
                    return
                }

                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    print((response as? NSHTTPURLResponse)?.statusCode)
                    completionHandler(success: false, result: nil, errorString: "Your request returned an invalid response")
                    return
                }

                guard let data = data else {
                    completionHandler(success: false, result: nil, errorString: "No data was returned by the request")
                    return
                }

                ParseApiClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)

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

    class func escapedParameters(parameters: [String : AnyObject]) -> String {

        var urlVars = [String]()

        for (key, value) in parameters {

            /* Make sure that it is a string value */
            let stringValue = "\(value)"

            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]

        }

        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    class func sharedInstance() -> ParseApiClient {
        struct Singleton {
            static var sharedInstance = ParseApiClient()
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
