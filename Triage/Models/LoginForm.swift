//
//  LoginForm.swift
//  Triage
//
//  Created by Tamer Bader on 8/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

class LoginForm {
    var emailAddress: String?
    var password: String?
    var currentElement: LoginFormElement?
    
    init() {
    }
    
    public func addEmail(email: String) {
        self.emailAddress = email
    }
    
    public func addPassword(password: String) {
        self.password = password
    }
    
    func saveInput(input: String) {
        guard let currentEl = currentElement else {return}
        switch currentEl {
        case .EMAIL_ADDRESS:
            self.addEmail(email: input)
        case .PASSWORD:
            self.addPassword(password: input)
        }
    }
    
    
    //
    public func nextField() -> Field {
        
        if (currentElement == nil) {
            self.currentElement = .EMAIL_ADDRESS
        } else {
            let currentElementNumber: Int = currentElement!.rawValue
            self.currentElement = LoginFormElement(rawValue: (currentElementNumber + 1))!
        }
        
        return generateField()
        
    }
    
    public func prevField() -> Field? {
        var savedTextFromPrevField: String = ""
        
        switch currentElement! {
        case .EMAIL_ADDRESS:
            savedTextFromPrevField = ""
        case .PASSWORD:
            savedTextFromPrevField = emailAddress!
        }
        
        let currentElementNumber: Int = currentElement!.rawValue
        
        if (currentElementNumber == 0) {
            return nil
        }
        
        self.currentElement = LoginFormElement(rawValue: (currentElementNumber - 1))!
        
        let field: Field = generateField()
        field.text = savedTextFromPrevField
        
        return field
        
    }
    
    public func generateField() -> Field {
        switch currentElement!{
        case .EMAIL_ADDRESS:
            return Field(title: "Welcome Back! What's your email?", placeholder: "Enter email address", contentType: .emailAddress, keyboardType: .emailAddress, infoType: .EMAIL_ADDRESS)
        case .PASSWORD:
            return Field(title: "What's your password", placeholder: "Enter Password", contentType: .newPassword, keyboardType: .default, infoType: .PASSWORD)
        }
    }
    
    
    
    
    
}

enum LoginFormElement: Int {
    case EMAIL_ADDRESS = 0
    case PASSWORD = 1
}
