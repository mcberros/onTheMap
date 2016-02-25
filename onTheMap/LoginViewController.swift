//
//  LoginViewController.swift
//  onTheMap
//
//  Created by Carmen Berros on 23/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if userTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            appDelegate.showAlert(self, message: "Empty Email or Password")
        } else {
            self.getSession()
        }
    }

    @IBAction func signUpButtonTouch(sender: AnyObject) {
        let urlString = ApisClient.Constants.BaseUdacityURL + ApisClient.Methods.SignUpMethod
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    private func getSession() {
        let urlString = ApisClient.Constants.BaseUdacityURL + ApisClient.Methods.SessionMethod
        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)

            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = "{\"udacity\": {\"username\": \"\(userTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                guard (error == nil) else {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Connection error")}
                    return
                }

                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    if (response as? NSHTTPURLResponse)?.statusCode == 403 {
                        dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Invalid email or password")}
                    } else {
                        dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "Your request returned an invalid response")}
                    }
                    return
                }

                guard let data = data else {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "No data was returned by the request")}
                    return
                }

                let newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))

                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "The login response data could not be parsed")}
                    return
                }

                guard let _ = parsedResult["account"]!!["registered"] as? Bool else{
                    dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: "The user does not appear as registered")}
                    return
                }

                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                self.completeLogin()

            }
            task.resume()
        }
    }

    private func completeLogin() {
        dispatch_async(dispatch_get_main_queue()) {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
}
