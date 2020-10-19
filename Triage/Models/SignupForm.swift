//
//  SignupForm.swift
//  Triage
//
//  Created by Tamer Bader on 8/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

class SignupForm {
    var emailAddress:String?
    var phoneNumber: String?
    var fullName: String?
    var password: String?
    var confirmPassword: String?
    var familyId: String?
    var currentFormEntry: SignupFormElement?
    
    init() {
    }
    
    public func addEmail(email: String) {
        self.emailAddress = email
    }
    public func addPhoneNumber(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    public func addFullName(fullName: String) {
        self.fullName = fullName
    }
    public func addPassword(password: String) {
        self.password = password
    }
    public func addConfirmPassword(password: String) {
        self.confirmPassword = password
    }
    public func addFamilyId(id: String) {
        self.familyId = id
    }
    
    func saveInput(input: String) {
        guard let currentFormElement = currentFormEntry else {return}
        switch currentFormElement {
        case .EMAIL_ADDRESS:
            addEmail(email: input)
        case .PHONE_NUMBER:
            addPhoneNumber(phoneNumber: input)
        case .FULL_NAME:
            addFullName(fullName: input)
        case .FAMILY_ID:
            addFamilyId(id: input)
        case .PASSWORD:
            addPassword(password: input)
        case .CONFIRM_PASSWORD:
            addConfirmPassword(password: input)
        }
    }
    
    public func nextField() -> Field {
        if (currentFormEntry == nil) {
            self.currentFormEntry = .EMAIL_ADDRESS
        } else {
            let currentFormEntryNumber: Int = currentFormEntry!.rawValue
            self.currentFormEntry = SignupFormElement(rawValue: (currentFormEntryNumber + 1))!
        }
        
        return generateField()
        
    }
    
    public func prevField() -> Field? {
        var savedTextFromPrevField: String = ""
        
        switch currentFormEntry {
        case .EMAIL_ADDRESS:
            savedTextFromPrevField = ""
        case .PHONE_NUMBER:
            savedTextFromPrevField = emailAddress!
        case .FULL_NAME:
            savedTextFromPrevField = phoneNumber!
        case .FAMILY_ID:
            savedTextFromPrevField = fullName!
        case .PASSWORD:
            savedTextFromPrevField = familyId!
        case .CONFIRM_PASSWORD:
            savedTextFromPrevField = ""
        case .none:
            print("wth")
        
        }
        
        let currentFormEntryNumber: Int = currentFormEntry!.rawValue
        
        if (currentFormEntryNumber == 0) {
            return nil
        }
        self.currentFormEntry = SignupFormElement(rawValue: (currentFormEntryNumber - 1))!
        
        
        let field: Field = generateField()
        field.text = savedTextFromPrevField
        
        return field
        
    }
    
    public func generateField() -> Field {
        
        switch currentFormEntry! {
        case .EMAIL_ADDRESS:
            return Field(title: "Let's get started. What's your email?", placeholder: "Enter email address", contentType: .emailAddress, keyboardType: .emailAddress, infoType: .EMAIL_ADDRESS)
        case .PHONE_NUMBER:
            return Field(title: "What's your phone number?", placeholder: "Enter Phone Number", contentType: .telephoneNumber, keyboardType: .numberPad, infoType: .PHONE_NUMBER)
        case .FULL_NAME:
            return Field(title: "What's your name?", placeholder: "Enter Full Name", contentType: .name, keyboardType: .namePhonePad, infoType: .FULL_NAME)
        case .FAMILY_ID:
            return Field(title: "Have a family id? If not, just leave blank", placeholder: "Enter Family ID", contentType: .username, keyboardType: .namePhonePad, infoType: .FAMILY_ID)
        case .PASSWORD:
            return Field(title: "Create your password", placeholder: "Enter Password", contentType: .newPassword, keyboardType: .default, infoType: .PASSWORD)
        case .CONFIRM_PASSWORD:
            return Field(title: "Confirm your password", placeholder: "Re-enter Password", contentType: .newPassword, keyboardType: .default, infoType: .CONFIRM_PASSWORD)
        }
        
    }
    
    public func isFinishedSigningUp() -> Bool {
        if (
            (emailAddress != nil && emailAddress != "")
            &&
            (phoneNumber != nil && phoneNumber != "")
            &&
            (fullName != nil && fullName != "")
            &&
            (password != nil && password != "")
            &&
            (confirmPassword != nil && confirmPassword != "")
            &&
            (password == confirmPassword)
            ) {
            return true
        } else {
            return false
        }
    }
    
    
    
}

enum SignupFormElement: Int {
    case EMAIL_ADDRESS = 0
    case PHONE_NUMBER = 1
    case FULL_NAME = 2
    case FAMILY_ID = 3
    case PASSWORD = 4
    case CONFIRM_PASSWORD = 5
}
