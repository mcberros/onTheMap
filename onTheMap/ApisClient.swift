//
//  ParseClient.swift
//  onTheMap
//
//  Created by Carmen Berros on 25/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import Foundation

class ApisClient : NSObject {

    var session: NSURLSession

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
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

    class func sharedInstance() -> ApisClient {

        struct Singleton {
            static var sharedInstance = ApisClient()
        }

        return Singleton.sharedInstance
    }
}