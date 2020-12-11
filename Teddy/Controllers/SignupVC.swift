//
//  SignupVC.swift
//  Triage
//
//  Created by Tamer Bader on 4/26/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appMottoLabel: UILabel!
    @IBOutlet weak var familyImageView: UIImageView!
    
    // Sign Up With Email
    @IBOutlet weak var emailSignupSuperView: UIView!
    @IBOutlet weak var emailIconCard: UIView!
    
    var desiredAuthFlow: AuthFlowMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    func setupView() {
        emailSignupSuperView.layer.cornerRadius = 10
        emailIconCard.layer.cornerRadius = 7
        
    }
    
    @IBAction func didTapEmailSignup(_ sender: UIButton) {
        print("Signing up with email")
        desiredAuthFlow = .SIGNUP
        self.performSegue(withIdentifier: "goToSignupWithEmail", sender: nil)
    }
    @IBAction func didTapSignIn(_ sender: UIButton) {
        desiredAuthFlow = .LOGIN
        self.performSegue(withIdentifier: "goToSignupWithEmail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToSignupWithEmail") {
            let destVC: SignupInfoVC = segue.destination as! SignupInfoVC
            destVC.authFlow = desiredAuthFlow!
        }
    }


}
