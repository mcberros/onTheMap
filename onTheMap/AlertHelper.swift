//
//  Alert.swift
//  onTheMap
//
//  Created by Carmen Berros on 15/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

class AlertHelper {
    static func showAlert(view: UIViewController, message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) {(_) in }

        alertController.addAction(dismissAction)
        view.presentViewController(alertController, animated: true, completion: nil)
    }
}
