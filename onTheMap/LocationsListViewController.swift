//
//  LocationsListViewController.swift
//  onTheMap
//
//  Created by Carmen Berros on 24/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController {

    var students: [StudentInformation]?

    var appDelegate: AppDelegate!
    
    @IBOutlet weak var studentsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        students = appDelegate.students
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        ParseApiClient.sharedInstance().getLocationsList() { (success, errorString) in
            if success {
                self.students = self.appDelegate.students
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentsTableView.reloadData()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.appDelegate.showAlert(self, message: errorString!)
                }
            }
        }
    }
}

extension LocationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentInformationTableViewCell"
        let student = students![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!

        cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
        cell.imageView!.image = UIImage(named: "Pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit


        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students!.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlString = students![indexPath.row].mediaURL
        if let url = NSURL(string: urlString) {
            if !UIApplication.sharedApplication().openURL(url){
                appDelegate.showAlert(self, message: "Invalid link")
            }
        }
    }
}
