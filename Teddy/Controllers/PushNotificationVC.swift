//
//  PushNotificationVC.swift
//  Triage
//
//  Created by Tamer Bader on 5/2/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class PushNotificationVC: UIViewController {

    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var enableSuperView: UIView!
    @IBOutlet weak var skipSuperView: UIView!
    var flow: PushNotificationFlow!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the View Controllers UI
        setupVC()
    }
    
    func setupVC() {
        
        // Button Setup
        self.enableSuperView.layer.cornerRadius = 20
        self.skipSuperView.layer.cornerRadius = 20
        self.skipSuperView.backgroundColor = UIColor.white
        self.skipSuperView.layer.borderWidth = 2
        self.skipSuperView.layer.borderColor = UIColor.init(red: 63/255, green: 131/255, blue: 239/255, alpha: 1.0).cgColor
        
    }
    @IBAction func didTapEnable(_ sender: UIButton) {
        registerForPushNotifications()
    }
    @IBAction func didTapSkip(_ sender: UIButton) {
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current() // 1
        .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
          granted, error in
            print("Permission granted: \(granted)") // 3
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
                // Route to next screen depending on flow
                switch self.flow! {
                case .SIGNUP:
                    self.performSegue(withIdentifier: "goToLocation", sender: nil)
                case .HOME:
                    self.navigationController?.popViewController(animated: true)
                }

            }
      }
        
    }
}

enum PushNotificationFlow {
    case SIGNUP
    case HOME
}


