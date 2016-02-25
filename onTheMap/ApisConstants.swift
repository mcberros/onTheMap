//
//  ClientConstants.swift
//  onTheMap
//
//  Created by Carmen Berros on 25/02/16.
//  Copyright © 2016 mcberros. All rights reserved.
//

extension ApisClient {

    struct Constants {
        static let BaseUdacityURL = "https://www.udacity.com/"
        static let BaseParseURL = "https://api.parse.com/"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }

    struct Methods {
        static let SessionMethod = "api/session"
        static let SignUpMethod = "account/auth#!/signup"
        static let GetStudentLocationsMethod = "1/classes/StudentLocation"
    }

    struct ParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
    }
}
