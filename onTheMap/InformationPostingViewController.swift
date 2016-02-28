//
//  InformationPostingViewController.swift
//  onTheMap
//
//  Created by Carmen Berros on 28/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var whereTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var firstStepView: UIView!
    @IBOutlet weak var secondStepView: UIView!

    @IBAction func findOnTheMapButtonTouch(sender: AnyObject) {
        firstStepView.hidden = true
        secondStepView.hidden = false
    }

    @IBAction func submitButtonTouch(sender: AnyObject) {
    }

    @IBAction func cancelButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
