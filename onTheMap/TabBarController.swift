//
//  TabBarController.swift
//  onTheMap
//
//  Created by Carmen Berros on 25/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var appDelegate: AppDelegate!

    @IBAction func logoutButtonItemTouch(sender: AnyObject) {
        logout()
    }

    @IBAction func pinButtonItemTouch(sender: AnyObject) {

    }


    @IBAction func refreshButtonItemTouch(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    private func logout() {
        let urlString = UdacityApiClient.Constants.BaseUdacityURL + UdacityApiClient.Methods.SessionMethod
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

            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard (error == nil) else{
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

                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))

                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "The logout response data could not be parsed")}
                    return
                }

                guard let _ = parsedResult["session"]!!["id"] as? String else{
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "There was an error in the parsed data for the logout")}
                    return
                }

                print(NSString(data: newData, encoding: NSUTF8StringEncoding))

                self.completeLogout()
            }
            task.resume()

        }

    }

    private func completeLogout() {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
