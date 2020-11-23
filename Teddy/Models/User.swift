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
    var familyID: String?
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
        caretaker.familyID = caretakerResponse.familyID
        
        return caretaker
    }
}

class Child: User {
    var dropoffs: [Dropoff] = []
    var nextDropoff: NextDropoff!
    
    static func modelDataFromResponse(childResponse: APIChildSuccessResponse) -> Child {
        let child: Child = Child()
        // Set info fields
        child._id = childResponse._id
        child.fullName = childResponse.fullName
        child.dropoffs = []
        for dropoffResponse in childResponse.dropoffs {
            child.dropoffs.append(Dropoff.modelDataFromResponse(dropoffResponse: dropoffResponse))
        }
        child.familyID = childResponse.familyID
        child.nextDropoff = NextDropoff.modelDataFromResponse(nextDropoffResponse: childResponse.nextDropoff)
        
        return child
    }
}

class Dropoff {
    var _id: String
    var latitude: String
    var longitude: String
    var radius: String
    var times: [String]
    var nickname: String
    
    init(withId id: String, withLatitude latitude: String, withLongitude longitude: String, withRadius radius: String, withTimes times: [String], withNickname nickname: String) {
        self._id = id
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.times = times
        self.nickname = nickname
    }
    
    static func modelDataFromResponse(dropoffResponse: APIDropoffSuccessResponse) -> Dropoff {
        
        let dropoff: Dropoff = Dropoff(
            withId: dropoffResponse._id,
            withLatitude: dropoffResponse.latitude,
            withLongitude: dropoffResponse.longitude,
            withRadius: dropoffResponse.radius,
            withTimes: dropoffResponse.times,
            withNickname: dropoffResponse.nickname)
        
        return dropoff
    }
}

class NextDropoff {
    var _id: String
    var nickname: String
    var time: String
    
    init(withId id: String, withNickname nickname: String, withTime time: String) {
        self._id = id
        self.nickname = nickname
        self.time = time
    }
    
    static func modelDataFromResponse(nextDropoffResponse: APINextDropoffSuccessResponse) -> NextDropoff {
        
        let nextDropoff: NextDropoff = NextDropoff(
            withId: nextDropoffResponse._id,
            withNickname: nextDropoffResponse.nickname,
            withTime: nextDropoffResponse.time)
        
        return nextDropoff
        
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
