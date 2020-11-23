//
//  MemberDecisionVC.swift
//  Triage
//
//  Created by Tamer Bader on 6/1/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class MemberDecisionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAddParent(_ sender: UIButton) {
        let textToShare = "\(AppData.shared.currentUser.fullName!) invites you to join Teddy Bear! You can download the app from this link. \(AppData.shared.currentUser.familyID!) is your code to join the family!"
         
        if let myWebsite = NSURL(string: "\(ApplicationProperties.appShareLink)") {
                let objectsToShare = [textToShare, myWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
         
                activityVC.popoverPresentationController?.sourceView = sender
                self.present(activityVC, animated: true, completion: nil)
            }
    }
    
    @IBAction func didTapAddChild(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goAddChild", sender: nil)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
