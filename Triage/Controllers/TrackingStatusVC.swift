//
//  TrackingStatusVC.swift
//  Triage
//
//  Created by Tamer Bader on 4/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class TrackingStatusVC: UIViewController {
    // View Outlets
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (TrackingService.shared.isServiceRunning()) {
            TrackingService.shared.startService(delegate: self)
        }
    }

}

extension TrackingStatusVC: ControllerUpdateDelegate {
    func didStartMonitoringLocation() {
        notificationView.backgroundColor = UIColor.green
        notificationText.text = "We are monitoring your location"
    }
    
    func didEnterTargetZone() {
        notificationView.backgroundColor = UIColor.blue
        notificationText.text = "Entered the target zone!"
    }
    
    func didLeaveTargetZone(_ didSpendEnougTime: Bool) {
        if (!didSpendEnougTime) {
            notificationView.backgroundColor = UIColor.red
            notificationText.text = "You left the area but didn't spend enough time"
        } else {
            notificationView.backgroundColor = UIColor.green
            notificationText.text = "You've spent enough time! Good Job!"
        }
    }
    
    
}
