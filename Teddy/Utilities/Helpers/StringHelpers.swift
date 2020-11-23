//
//  StringHelpers.swift
//  Triage
//
//  Created by Tamer Bader on 9/11/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension String {
    // Cleanup Methods
    
    // Trim trailing white spaces in text from autocorrect
    func trimTrailingWhitespaces() -> String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
    
    // Remove non digits from phone number entry
    func cleanupPhoneNumber() -> String {
        return self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
    
    // Validation Methods
    
    // Valid Email Address
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    // Valid Phone Number
    func isValidPhone() -> Bool {
        let phoneRegEx = "[0-9]{10}"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        
        let cleanNumber = self.cleanupPhoneNumber()
        return phonePred.evaluate(with: cleanNumber)
    }
    
    // Valid Password
    func isValidPassword() -> Bool {
        let passRegex = "[a-zA-Z0-9!@#$&*]{6,}"
        let passPred = NSPredicate(format: "SELF MATCHES %@", passRegex)
        print("RES: \(passPred.evaluate(with: self))")
        return passPred.evaluate(with: self)
    }
    
    func validatePassword() -> (Bool,String) {
        var passwordHints = ""
        var numOptionsCorrect = 0
        
        // Check For Digits
        let digitRegex = "[a-zA-Z0-9!@#$&*]{6,}"
        let digitPred = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        
        if (digitPred.evaluate(with: self)) {
            passwordHints += "✅ 6+ Characters Long\n"
            numOptionsCorrect+=1
        } else {
            passwordHints += "❌ 6+ Characters Long\n"
        }
        
        // Check For Special Characters
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            passwordHints += "✅ Contains Special Character\n"
            numOptionsCorrect+=1
        }else{
            passwordHints += "❌ Contains Special Character\n"
        }
        
        // Check For Uppercase Characters
        let uppercaseRegex = try! NSRegularExpression(pattern: ".*[A-Z].*", options: NSRegularExpression.Options())
        if uppercaseRegex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            passwordHints += "✅ Contains Uppercase Character\n"
            numOptionsCorrect+=1
        }else{
            passwordHints += "❌ Contains Uppercase Character\n"
        }
        
        if (numOptionsCorrect == 3) {
            return (true, passwordHints)
        } else {
            return (false, passwordHints)
        }
        
    }
}
