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
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pinButtonItemTouch(sender: AnyObject) {

    }


    @IBAction func refreshButtonItemTouch(sender: AnyObject) {
    }
}
