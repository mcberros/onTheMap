//
//  LocationsListViewController.swift
//  onTheMap
//
//  Created by Carmen Berros on 24/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController {
    
    @IBOutlet weak var studentsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        ParseApiClient.sharedInstance().getLocationsList() { (success, errorString) in
            if success {
                //self.students = ParseApiClient.sharedInstance().students
                self.refreshView()
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    AlertHelper.showAlert(self, message: errorString!)
                }
            }
        }
    }

    func refreshView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.studentsTableView.reloadData()
        }
    }
}

extension LocationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentInformationTableViewCell"
        let students = Students.sharedInstance().students
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!

        cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
        cell.imageView!.image = UIImage(named: "Pin")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit


        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let students = Students.sharedInstance().students
        return students.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let students = Students.sharedInstance().students
        let urlString = students[indexPath.row].mediaURL
        if let url = NSURL(string: urlString) {
            if !UIApplication.sharedApplication().openURL(url){
                AlertHelper.showAlert(self, message: "Invalid link")
            }
        }
    }
}
