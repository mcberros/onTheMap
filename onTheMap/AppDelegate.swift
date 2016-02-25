//
//  AppDelegate.swift
//  onTheMap
//
//  Created by Carmen Berros on 23/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var students: [StudentInformation] = [StudentInformation]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}


extension AppDelegate {
    func showAlert(view: UIViewController, message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) {(_) in }

        alertController.addAction(dismissAction)
        view.presentViewController(alertController, animated: true, completion: nil)
    }
}
