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

    let baseUdacityURL = "https://www.udacity.com/"
    let sessionMethod = "api/session"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if userTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert("Empty Email or Password")
        } else {
            self.getSession()
        }
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) {(_) in }

        alertController.addAction(dismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    private func getSession() {
        let urlString = baseUdacityURL + sessionMethod
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)

        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                dispatch_async(dispatch_get_main_queue()){self.showAlert("Connection error")}
                return
            }

            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print(response)
                if (response as? NSHTTPURLResponse)?.statusCode == 403 {
                    dispatch_async(dispatch_get_main_queue()){self.showAlert("Invalid email or password")}
                } else {
                    dispatch_async(dispatch_get_main_queue()){self.showAlert("Your request returned an invalid response")}
                }
                return
            }

            guard let data = data else {
                dispatch_async(dispatch_get_main_queue()){self.showAlert("No data was returned by the request")}
                return
            }

            let newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}
