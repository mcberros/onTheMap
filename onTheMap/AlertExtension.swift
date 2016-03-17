//
//  Alert.swift
//  onTheMap
//
//  Created by Carmen Berros on 15/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) {(_) in }

        alertController.addAction(dismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

