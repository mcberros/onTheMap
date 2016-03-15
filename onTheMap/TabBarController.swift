//
//  TabBarController.swift
//  onTheMap
//
//  Created by Carmen Berros on 25/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    @IBAction func logoutButtonItemTouch(sender: AnyObject) {
        UdacityApiClient.sharedInstance().logout(){ (success, errorString) in
            if success {
                self.completeLogout()
            } else {
                dispatch_async(dispatch_get_main_queue()){AlertHelper.showAlert(self, message: errorString!)}
            }
        }
    }


    @IBAction func refreshButtonItemTouch(sender: AnyObject) {
        ParseApiClient.sharedInstance().getLocationsList() { (success, errorString) in
            if success {
                if let selectedView = self.selectedViewController as? LocationsListViewController {
                    selectedView.refreshView()
                } else if let selectedView = self.selectedViewController as? MapViewController {
                    selectedView.refreshView()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    AlertHelper.showAlert(self, message: errorString!)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func completeLogout() {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
