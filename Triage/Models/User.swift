//
//  User.swift
//  Triage
//
//  Created by Tamer Bader on 4/26/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class User {
    var fullName: String?
    var _id: String?
}

class Caretaker: User {
    var emailAddress: String?
    var phoneNumber: String?
    
    static func modelDataFromResponse(caretakerResponse: APICaretakerSuccessResponse) -> Caretaker {
        let caretaker: Caretaker = Caretaker()
        // Set info fields
        caretaker._id = caretakerResponse._id
        caretaker.fullName = caretakerResponse.fullName
        caretaker.emailAddress = caretakerResponse.emailAddress
        caretaker.phoneNumber = caretakerResponse.phoneNumber
        
        return caretaker
    }
}

class Child: User {
    var dropoffs: [Dropoff] = []
    
    static func modelDataFromResponse(childResponse: APIChildSuccessResponse) -> Child {
        let child: Child = Child()
        // Set info fields
        child._id = childResponse._id
        child.fullName = childResponse.fullName
        child.dropoffs = []
        for dropoffResponse in childResponse.dropoffs {
            child.dropoffs.append(Dropoff.modelDataFromResponse(dropoffResponse: dropoffResponse))
        }
        
        return child
    }
}

class Dropoff {
    var _id: String
    var latitude: String
    var longitude: String
    var radius: String
    var times: [String]
    
    init(withId id: String, withLatitude latitude: String, withLongitude longitude: String, withRadius radius: String, withTimes times: [String]) {
        self._id = id
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.times = times
    }
    
    static func modelDataFromResponse(dropoffResponse: APIDropoffSuccessResponse) -> Dropoff {
        
        let dropoff: Dropoff = Dropoff(
            withId: dropoffResponse._id,
            withLatitude: dropoffResponse.latitude,
            withLongitude: dropoffResponse.longitude,
            withRadius: dropoffResponse.radius,
            withTimes: dropoffResponse.times)
        
        return dropoff
    }
}

class Field {
    var title: String
    var text: String?
    var subtitle: String?
    var placeholder: String
    var contentType: UITextContentType
    var keyboardType: UIKeyboardType
    var infoType: SignupFormElement
    
    init(title: String, subtitle: String?=nil, text: String?=nil, placeholder: String, contentType: UITextContentType, keyboardType: UIKeyboardType, infoType: SignupFormElement) {
        self.title = title
        if(subtitle != nil) {
            self.subtitle = subtitle
        }
        if (text != nil) {
            self.text = text
        }
        self.placeholder = placeholder
        self.contentType = contentType
        self.keyboardType = keyboardType
        self.infoType = infoType
    }
    
}
