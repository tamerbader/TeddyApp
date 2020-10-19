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
    

    @IBAction func didTapAddChild(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goAddChild", sender: nil)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
