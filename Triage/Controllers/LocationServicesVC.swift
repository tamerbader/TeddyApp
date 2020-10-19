//
//  LocationServicesVC.swift
//  Triage
//
//  Created by Tamer Bader on 5/2/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import CoreLocation

class LocationServicesVC: UIViewController {
    @IBOutlet weak var enableSuperView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()

        // Do any additional setup after loading the view.
    }
    
    func setupVC() {
        // Button Setup
       self.enableSuperView.layer.cornerRadius = 20
    }
    @IBAction func didTapEnableLocation(_ sender: UIButton) {
        //LocationService.shared.requestLocationAccess()
        self.performSegue(withIdentifier: "goToMainVC", sender: nil)

    }
    
}
