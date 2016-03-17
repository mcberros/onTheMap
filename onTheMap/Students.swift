//
//  Students.swift
//  onTheMap
//
//  Created by Carmen Berros on 17/03/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

import Foundation

class Students: NSObject {
    var students: [StudentInformation] = [StudentInformation]()

    override init() {
        super.init()
    }

    class func sharedInstance() -> Students {
        struct Singleton {
            static var sharedInstance = Students()
        }
        return Singleton.sharedInstance
    }
}