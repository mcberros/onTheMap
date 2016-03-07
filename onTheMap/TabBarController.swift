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
        UdacityApiClient.sharedInstance().logout(){ (success, errorString) in
            if success {
                self.completeLogout()
            } else {
                dispatch_async(dispatch_get_main_queue()){self.appDelegate.showAlert(self, message: errorString!)}
            }
        }
    }


    @IBAction func refreshButtonItemTouch(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    private func completeLogout() {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
