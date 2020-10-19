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
    
    // Sign up with Google
    @IBOutlet weak var googleSignupSuperView: UIView!
    @IBOutlet weak var googleIconCard: UIView!
    
    // Sign Up With Email
    @IBOutlet weak var emailSignupSuperView: UIView!
    @IBOutlet weak var emailIconCard: UIView!
    
    var desiredAuthFlow: AuthFlowMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge, ]) { // 2
            granted, error in
            print("Permission granted: \(granted)") // 3
        }
        LocationService.shared.requestLocationAccess()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        googleSignupSuperView.layer.cornerRadius = 10
        googleIconCard.layer.cornerRadius = 7
        emailSignupSuperView.layer.cornerRadius = 10
        emailIconCard.layer.cornerRadius = 7
        
    }
    @IBAction func didTapGoogleSignUp(_ sender: UIButton) {
        print("Signing up with google")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
