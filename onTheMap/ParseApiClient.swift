//
//  ParseApiClient.swift
//  onTheMap
//
//  Created by Carmen Berros on 07/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import Foundation

class ParseApiClient: NSObject {
    var session: NSURLSession

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
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
