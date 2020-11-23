//
//  SignupInfoVC+KeyboardNotification.swift
//  Triage
//
//  Created by Tamer Bader on 9/9/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import UIKit

extension SignupInfoVC {
    
    func registerKeyboardNotifications() {
        // Keyboard Listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func handleKeyboardNotification(_ notification: Notification) {

        if let userInfo = notification.userInfo {
            
            // Grabs the keyboard frame from the responder
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            
            // Determines Notification Type to Adjust Constraints
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            // Call this before animations in order to make sure all views were laid out beforehand.
            self.view.layoutIfNeeded()
            
            // Set the continue buttons bottom contraint depending on the keyboard height and if presenting
            self.continueButtonBottomConstraint?.constant = isKeyboardShowing ? (keyboardFrame!.height + 10) : 20
            
            // Animate the button slide up along with the keyboard
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
               self.view.layoutIfNeeded()
            }, completion: { (completed) in
               print(completed)
            })
       
        }
    }
}
