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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if userTextField.text!.isEmpty {
            print("Not valid username")
        } else if passwordTextField.text!.isEmpty {
            print("Not valid password")
        } else {
            self.getSession()
        }
    }

    private func getSession() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(userTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5))
            print(NSString(data: newData!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}
