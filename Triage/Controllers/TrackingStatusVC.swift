//
//  TrackingStatusVC.swift
//  Triage
//
//  Created by Tamer Bader on 4/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class TrackingStatusVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    @IBOutlet weak var addMemberView: UIView!
    @IBOutlet weak var addMemberButton: UIButton!
    
    @IBOutlet weak var memberTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update the family data
        
        APIGetFamilyRequest().dispatch(
            onSuccess: {(successResponse) in
                AppData.shared.saveFromFamilyResponse(familyResponse: successResponse)
                
                DispatchQueue.main.async {
                    self.setupView()
                    
                    // Check if fully registered and has atleast 1 child
                    if (self.isTrackingServiceReady()) {
                        self.isStatusBarEnabled(status: .ENABLED)
                        
                        // Enable Location Services
                        LocationService.shared.startLocationService()
                        
                        // Stop all active region monitors to reset
                        LocationService.shared.stopAllRegionMonitors()
                        
                        // Start Tracking All Children
                        for child in AppData.shared.children {
                            TrackingService.shared.startTracking(withChild: child, withDelegate: self)
                        }
                        
                    } else {
                        self.isStatusBarEnabled(status: .DISABLED)
                    }
                }
                
            },
            onFailure: {(errorResponse, error) in
                print("I'm scared. I dont have a guardian :(")
                print(errorResponse)
                print(error)
            })
        
        // Refresh User Data
      /*  APIGetUserRequest().dispatch(
             onSuccess: { (successResponse) in
                Caretaker.refreshDataFromResponse(guardianResponse: successResponse)
                DispatchQueue.main.async {
                    self.setupView()
                    
                    // Check if fully registered and has atleast 1 child
                    if (self.isTrackingServiceReady()) {
                        self.isStatusBarEnabled(status: .ENABLED)
                        
                        // Enable Location Services
                        LocationService.shared.startLocationService()
                        
                        // Start Tracking All Children
                        for child in AppData.shared.currentUser.children {
                            TrackingService.shared.startTracking(withChild: child, withDelegate: self)
                            
                        }
                    } else {
                        self.isStatusBarEnabled(status: .DISABLED)
                        
                    }
                }
         },
             onFailure: { (errorResponse, error) in
                 print("I'm scared. I dont have a guardian :(")
                 print(errorResponse)
                 print(error)
                 
         }) */
        
        
        
        
    }
    
    @IBAction func didTapStatusBar(_ sender: UIButton) {
        
    }
    
    
    @IBAction func didTapAddMember(_ sender: UIButton) {
        self.performSegue(withIdentifier: "trackingToAddMember", sender: nil)
    }
    
    func setupView() {
        // Set Flow
        AppData.shared.currentFlow = .MAINPAGE
        
        // Setup TableView
        memberTable.delegate = self
        memberTable.dataSource = self
        memberTable.tableFooterView = UIView()
        
        // Setting up views
        self.addMemberView.layer.cornerRadius = self.addMemberView.frame.height/2
        self.addMemberView.backgroundColor = UIColor.teddy_blue
        
    }
    
    
    func isTrackingServiceReady() -> Bool {
        if (!(AppData.shared.children.count > 0)) {
            return false
        } else {
            return true
        }
    }
    
    
    
    func isStatusBarEnabled(status: TRACKING_STATUS) {
        switch status {
        case .ENABLED:
            self.statusView.backgroundColor = UIColor.teddy_green
            self.statusLabel.text = "Tracking Service Status: Enabled"
        case .DISABLED:
            self.statusView.backgroundColor = UIColor.red
            self.statusLabel.text = "Tracking Service Status: Disabled (Tap to Fix)"
        }
    }
    
    

}

enum TRACKING_STATUS {
    case ENABLED
    case DISABLED
}

extension TrackingStatusVC: ControllerUpdateDelegate {
    func didExitRegion(withChild child: Child) {
       /* let alert = UIAlertController(title: "Region Monitoring", message: "\(child.fullName!) has left region", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true)*/
    }
    
    func didDropoff(withChild child: Child) {
       /* let alert = UIAlertController(title: "Dropped Off", message: "Successfully Dropped off \(child.fullName!)", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true)*/
        
        //get the notification center
  /*      let center =  UNUserNotificationCenter.current()

        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Teddy Bear"
        content.subtitle = "Dropoff Notification"
        content.body = "\(child.fullName!) has been dropped off!"
        content.sound = UNNotificationSound.default

        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)

        //create request to display
        let request = UNNotificationRequest(identifier: "\(child.fullName!)", content: content, trigger: trigger)

        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }*/
    }
    
    func didStartTracking(withChild child: Child) {
        
        /*
        let alert = UIAlertController(title: "Started Tracking", message: "Started Tracking \(child.fullName!)", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true)*/
        
    }
    
    func didEnterRegion(withChild child: Child) {
     /*   let alert = UIAlertController(title: "Region Monitoring", message: "\(child.fullName!) entered the region", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true) */
    }
    
  
    
    
}

extension TrackingStatusVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AppData.shared.children.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackingStatusCell = tableView.dequeueReusableCell(withIdentifier: "trackingStatusCell") as! TrackingStatusCell
        
        let currentChild: Child = AppData.shared.children[indexPath.item]
        
        cell.profileImage.image = UIImage(named: "user")
        cell.nameLabel.text = "\(currentChild.fullName!)"
        cell.dropoffReminderLabel.text = "Next Dropoff Time: Monday @ 2pm"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    
}
