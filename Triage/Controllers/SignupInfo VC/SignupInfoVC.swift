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
        passwordHints.attributedText = NSAttributedString(string: "❌ Uppercase Letters\n✅ Uppercase Letters\n✅ Uppercase Letters", attributes:attributes)
        
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
            if (signupForm.currentFormEntry != nil && signupForm.currentFormEntry! == .CONFIRM_PASSWORD) {
                if (!(signupForm.password! == inputText)) {
                    self.infoTextField.shake()
                    return
                }
            }
            
            if (signupForm.currentFormEntry != nil && signupForm.currentFormEntry! == .FAMILY_ID) {
                // Server check the Family ID
                if (!inputText.isEmpty) {
                    var isSuccessful: Bool = false
                    APICheckFamilyIdRequest(familyId: inputText).dispatch(
                        onSuccess: {
                            print("All Good to go!")
                            isSuccessful = true
                        },
                        onFailure: { (error,err) in
                            print("WRONG FAMILY ID!")
                            self.infoTextField.shake()
                            isSuccessful = false
                            return
                        })
                    
                    if (!isSuccessful) {
                        enableHints(value: true)
                        passwordHints.text = "❌ Invalid Family ID"
                        return
                    } else {
                        passwordHints.text = ""
                        enableHints(value: false)
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
        
        continueButtonView.layer.cornerRadius = (continueButtonView.frame.height * 0.5)
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
