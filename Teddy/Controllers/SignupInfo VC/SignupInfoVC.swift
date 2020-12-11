//
//  SignupInfoVC.swift
//  Triage
//
//  Created by Tamer Bader on 4/26/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import CoreLocation

class SignupInfoVC: UIViewController {

    // Outlets
    @IBOutlet weak var infoFieldTitle: UILabel!
    @IBOutlet weak var infoFieldSuperView: UIView!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet var dividerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var backButtonImage: UIImageView!
    @IBOutlet var continueButtonView: UIView!
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var continueButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var passwordHints: UITextView!
    
    // Controller Variables
    var authFlow: AuthFlowMethod!
    var signupForm: SignupForm = SignupForm()
    var loginForm: LoginForm = LoginForm()
    var currentInfoType: SignupFormElement?
    var didFinishSignup: Bool = false
    var location: CLLocation?
    
    // Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Keyboard Notifications
        registerKeyboardNotifications()
        
        // Setup the View
        setupView()
        
        // Request the next form
        nextForm()
       
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font: UIFont(fontStyle: .AspiraMedium, size: 17)]
        passwordHints.attributedText = NSAttributedString(string: "❌ Uppercase Letters\n✅ Uppercase Letters\n✅ Uppercase Letters", attributes:attributes as [NSAttributedString.Key : Any])
        
        enableHints(value: false)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToMap") {
            let mapVC: MapRadiusVC = segue.destination as! MapRadiusVC
            mapVC.coordinates = self.location!.coordinate
        }
    }
    
    // IBActions
    
    @IBAction func didTapBack(_ sender: UIButton) {
        prevForm()
    }
    
    @IBAction func didTapContinue(_ sender: UIButton) {
        switch authFlow {
        case .SIGNUP:
            guard let inputText = infoTextField.text else {return}
            
            // Boolean value to hold process until validation finishes
            var isValidatingFromAPI: Bool = false
            
            if (signupForm.currentFormEntry != nil && signupForm.currentFormEntry! == .CONFIRM_PASSWORD) {
                if (!(signupForm.password! == inputText)) {
                    self.infoTextField.shake()
                    return
                }
            }
            
            if (signupForm.currentFormEntry != nil && signupForm.currentFormEntry! == .FAMILY_ID) {
                // Server check the Family ID
                if (!inputText.isEmpty) {
                    
                    // Flag the method as fetching from API
                    isValidatingFromAPI = true
                    
                    
                    APICheckFamilyIdRequest(familyId: inputText).dispatch(
                        onSuccess: {
                            print("All Good to go!")
                            self.passwordHints.text = ""
                            self.enableHints(value: false)
                            self.signupForm.saveInput(input: inputText.trimTrailingWhitespaces())
                            self.disableContinueButton()
                            self.nextForm()
                            
                        },
                        onFailure: { (error,err) in
                            print("WRONG FAMILY ID!")
                            self.enableHints(value: true)
                            self.passwordHints.text = "❌ Invalid Family ID"
                            self.infoTextField.shake()
                            return
                        })
                    
                    // This will be reached before API responds. If Fetching from API just escape. API Response logic will handle
                    if (isValidatingFromAPI) {
                        return
                    }
                }
            }
            signupForm.saveInput(input: inputText.trimTrailingWhitespaces())
        case .LOGIN:
            print("Login Save Input")
            guard let inputText = infoTextField.text else {return}
            loginForm.saveInput(input: inputText.trimTrailingWhitespaces())

        case .none:
            print("wth")
        }
        
        
        disableContinueButton()
        nextForm()
    }
    
    func setupView() {
        infoFieldSuperView.backgroundColor = UIColor.white
        
       // continueButtonView.layer.cornerRadius = (continueButtonView.frame.height * 0.5)
        dividerView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.93, alpha: 1.00)
        
        infoTextField.delegate = self
        
        infoTextField.addTarget(self, action: #selector(SignupInfoVC.textFieldDidChange(_:)),
        for: .editingChanged)
        
        disableContinueButton()
        
        passwordHints.text = ""

    }

    
    
    
}

extension SignupInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        infoTextField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkFormEntry()
    }
    
}

enum AuthFlowMethod {
    case LOGIN
    case SIGNUP
}
