//
//  AppData.swift
//  Triage
//
//  Created by Tamer Bader on 6/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import MapKit
class AppData {
    static let shared = AppData()
    
    var caretakers: [Caretaker] = []
    var children: [Child] = []
    
    var currentLocation: CLLocationCoordinate2D?
    
    
    var guardians: [Caretaker] = []
    var currentUser: Caretaker = Caretaker()
    var currentUserJWT: String = ""
    
    var currentFlow: Flow?
    
    
    func saveFromFamilyResponse(familyResponse: APIGetFamilySuccessResponse) -> Void {
        // Clear the data
        AppData.shared.caretakers = []
        AppData.shared.children = []
        
        // Set Caretakers
        for caretaker in familyResponse.caretakers {
            AppData.shared.caretakers.append(Caretaker.modelDataFromResponse(caretakerResponse: caretaker))
            
            // Set the current user object
            if (caretaker._id == AppData.shared.currentUser._id) {
                AppData.shared.currentUser = Caretaker.modelDataFromResponse(caretakerResponse: caretaker)
            }
        }
        
        // Set Childern
        for child in familyResponse.children {
            AppData.shared.children.append(Child.modelDataFromResponse(childResponse: child))
        }
        
    }
    
    func getChild(withChildId id: String) -> Child? {
        for child in children {
            if (child._id == id) {
                return child
            }
        }
        
        return nil
    }
    
    func resetData() {
        self.caretakers = []
        self.children = []
        self.currentLocation = nil
        self.currentUser = Caretaker()
        self.currentUserJWT = ""
        self.currentFlow = nil
    }
}
