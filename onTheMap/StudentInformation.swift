//
//  StudentInformation.swift
//  onTheMap
//
//  Created by Carmen Berros on 24/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import Foundation

struct StudentInformation {
    var objectId: String
    var uniqueKey: String
    var mediaURL: String
    var firstName: String
    var lastName: String
    var mapString: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String

    init(dictionary: [String: AnyObject]){
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mapString = dictionary["mapString"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        createdAt = dictionary["createdAt"] as! String
        updatedAt = dictionary["updatedAt"] as! String
    }

    static func studentsFromResults(results: [[String: AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()

        for result in results {
            students.append(StudentInformation(dictionary: result))
        }

        return students
    }
}
