//
//  UdacityApiClientConstants.swift
//  onTheMap
//
//  Created by Carmen Berros on 25/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

extension UdacityApiClient {

    struct Constants {
        static let BaseUdacityURL = "https://www.udacity.com/"
    }

    struct Methods {
        static let SessionMethod = "api/session"
        static let SignUpMethod = "account/auth#!/signup"
        static let GetStudentInfo = "api/users/{user_id}"
    }

    struct URLSKeys {
        static let UserId = "user_id"
    }
}
