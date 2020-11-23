//
//  SignupInfoVC+FormController.swift
//  Triage
//
//  Created by Tamer Bader on 9/9/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import UIKit

extension SignupInfoVC {
    
    func nextForm() {
        
        switch authFlow {
        case .LOGIN:
            AppData.shared.currentFlow = .LOGIN
            if (loginForm.currentElement != nil && loginForm.currentElement! == .PASSWORD) {
                // Make Login Request
                APILoginRequest(emailAddress: loginForm.emailAddress!, password: loginForm.password!).dispatch(
                    onSuccess: { (successResponse) in
                        AppData.shared.currentUser._id = successResponse.user_id
                        AppData.shared.currentUserJWT = successResponse.jwt
                        
                        // Save AuthToken
                        let defaults = UserDefaults.standard
                        defaults.set(successResponse.jwt, forKey: "jwt")
                        defaults.set(successResponse.user_id, forKey: "_id")
                        
                        self.didFinishSignup = true
                        
                        // Refresh User Data
                        
                        APIGetFamilyRequest().dispatch(
                             onSuccess: { (successResponse) in
                                AppData.shared.saveFromFamilyResponse(familyResponse: successResponse)
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "goToTrackingStatus", sender: nil)
                                }
                         },
                             onFailure: { (errorResponse, error) in
                                 print("I'm scared. I dont have a guardian :(")
                                 print(errorResponse ?? "error response")
                                 print(error)
                                 
                         })
                        
                        
                        
                        
                }, onFailure: { (errorResponse, error) in
                    print("We can't log you in :(")
                    print(errorResponse ?? "error response")
                    print(error)
                    
                    self.enableHints(value: true)
                    self.passwordHints.text = "❌ Invalid email address or password"
                    self.infoTextField.shake()
                })
            } else {
                nextLoginForm()
            }
        case .SIGNUP:
            AppData.shared.currentFlow = .SIGNUP
             if (signupForm.currentFormEntry != nil && signupForm.currentFormEntry! == .CONFIRM_PASSWORD) {
                           // Register User
                APIRegisterRequest(fullName: signupForm.fullName!, emailAddress: signupForm.emailAddress!, phoneNumber: signupForm.phoneNumber!, password: signupForm.password!, familyId: signupForm.familyId).dispatch(
                               onSuccess: { (successResponse) in
                                print("We've Successfully Registered You!")
                                AppData.shared.currentUser._id = successResponse.user_id
                                AppData.shared.currentUserJWT = successResponse.jwt
                                
                                // Save AuthToken
                                let defaults = UserDefaults.standard
                                defaults.set(successResponse.jwt, forKey: "jwt")
                                defaults.set(successResponse.user_id, forKey: "_id")
                                
                                
                                self.didFinishSignup = true
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "goToFamily", sender: nil)
                                }
                           },
                               onFailure: { (errorResponse, error) in
                                   print("We can't register you :(")
                                   print(errorResponse ?? "error response")
                                   print(error)
                           })
             } else {
                nextSignupForm()
             }
        case .none:
            print("wth")
        }
        
    }

    func prevForm() {
                
        
        switch authFlow {
        case .LOGIN:
            prevLoginForm()
        case .SIGNUP:
            prevSignupForm()
        case .none:
            print("wth")
        }
        
    }

    func nextLoginForm() {
        let nextField: Field = loginForm.nextField()
        setupFieldView(field: nextField)
        
    }

    func nextSignupForm() {
        let nextField: Field = signupForm.nextField()
        setupFieldView(field: nextField)
    }

    func prevSignupForm() {
        let prevField: Field? = signupForm.prevField()
        if (prevField != nil) {
            setupFieldView(field: prevField!)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    func prevLoginForm() {
        let prevField: Field? = loginForm.prevField()
        
        if (prevField != nil) {
            setupFieldView(field: prevField!)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func setupFieldView(field: Field) {
        self.currentInfoType = field.infoType
        self.infoFieldTitle.text = field.title
        self.infoTextField.text = ""
        self.infoTextField.placeholder = field.placeholder
        self.infoTextField.textContentType = field.contentType
        self.infoTextField.keyboardType = field.keyboardType
        self.infoTextField.autocorrectionType = .yes
        
        infoTextField.becomeFirstResponder()
        self.infoTextField.reloadInputViews()
        
        if (field.contentType == .newPassword) {
            self.infoTextField.isSecureTextEntry = true
        } else {
            self.infoTextField.isSecureTextEntry = false
        }
        
        if (field.infoType == .FAMILY_ID) {
            enableContinueButton()
        }
        
        if (field.text != nil) {
            self.infoTextField.text = field.text!
        }
        
        // Change Back and Close Buttons
        switch authFlow! {
        case .SIGNUP:
            if (signupForm.currentFormEntry! == .EMAIL_ADDRESS) {
                backButtonImage.image = UIImage(named: "close")
            } else {
                backButtonImage.image = UIImage(named: "back")
            }
            
            if (signupForm.currentFormEntry! == .PASSWORD) {
                enableHints(value: true)
                guard let inputText = infoTextField.text else {return}
                let res = inputText.validatePassword()
                if (res.0 == true) {
                    enableContinueButton()
                } else {
                    disableContinueButton()
                }
                
                passwordHints.text = res.1
            } else {
                enableHints(value: false)
            }
            
            if (signupForm.currentFormEntry! == .CONFIRM_PASSWORD) {
                enableHints(value: true)
                passwordHints.text = "❌ Password Matches"
            }
            
        case .LOGIN:
            enableHints(value: false)
            if (loginForm.currentElement! == .EMAIL_ADDRESS) {
                backButtonImage.image = UIImage(named: "close")
            } else {
                backButtonImage.image = UIImage(named: "back")
            }
        }

        
    }
    
    func checkFormEntry() {
        guard let inputText = infoTextField.text else {return}
        guard let currAuthFlow = authFlow else {return}
        switch currAuthFlow {
        case .SIGNUP:
            guard let currFormEntry = signupForm.currentFormEntry else {return}
            switch currFormEntry {
            case .EMAIL_ADDRESS:
                if (inputText.isValidEmail()) {
                    enableContinueButton()
                } else {
                    disableContinueButton()
                }
            case .FULL_NAME:
                enableContinueButton()
            case .PHONE_NUMBER:
                if (inputText.isValidPhone()) {
                    enableContinueButton()
                } else {
                    disableContinueButton()
                }
            case .PASSWORD:
                let res = inputText.validatePassword()
                if (res.0 == true) {
                    enableContinueButton()
                } else {
                    disableContinueButton()
                }
                
                passwordHints.text = res.1
            case .CONFIRM_PASSWORD:
                guard let prevPassword = signupForm.password else {return}
                if (prevPassword == inputText) {
                    enableContinueButton()
                    passwordHints.text = "✅ Password Matches"
                } else {
                    disableContinueButton()
                    passwordHints.text = "❌ Password Matches"
                }
            case .FAMILY_ID:
                // Check with Server if valid family ID
                if (inputText.isEmpty) {
                    passwordHints.text = ""
                }
                
                enableContinueButton()
            }
        case .LOGIN:
            guard let currFormEntry = loginForm.currentElement else {return}
            switch currFormEntry {
            case .EMAIL_ADDRESS:
                enableContinueButton()
            case .PASSWORD:
                enableContinueButton()
            }
        }
    }
    
    func disableContinueButton() {
        self.continueButton.isEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.continueButtonView.backgroundColor = UIColor.teddy_disabledBlue
        })
    }
    
    func enableContinueButton() {
        self.continueButton.isEnabled = true
        UIView.animate(withDuration: 0.2, animations: {
            self.continueButtonView.backgroundColor = UIColor.teddy_blue
        })
        
    }
    
    func enableHints(value: Bool) {
        if (value) {
            passwordHints.isHidden = false
        } else  {
            passwordHints.isHidden = true
        }
    }
    
}
