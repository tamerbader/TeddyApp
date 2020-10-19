//
//  AppData.swift
//  Triage
//
//  Created by Tamer Bader on 6/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
class AppData {
    static let shared = AppData()
    
    var caretakers: [Caretaker] = []
    var children: [Child] = []
    
    
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
        }
        
        // Set Childern
        for child in familyResponse.children {
            AppData.shared.children.append(Child.modelDataFromResponse(childResponse: child))
        }
        
    }
}
