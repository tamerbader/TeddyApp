//
//  SettingsVC.swift
//  Teddy
//
//  Created by Tamer Bader on 12/6/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var navigationBarTitle: UILabel!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the VC
        setupVC()
        
        
    }
    
    
    // IB Actions
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupVC() {
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
    }
    
}


extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            let appData: AppData = AppData.shared
            let numOfFamilyMembers = (appData.caretakers.count + appData.children.count)
            return numOfFamilyMembers
        } else {
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "My Family"
        } else {
            return "Logout"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            // My Family Section
            let cell: SettingsFamilyCell = tableView.dequeueReusableCell(withIdentifier: "settingsFamilyCell") as! SettingsFamilyCell
            
            if (indexPath.item < AppData.shared.caretakers.count) {
                // Setup Caretaker Cell
                let caretaker: Caretaker = AppData.shared.caretakers[indexPath.item]
                var caretakerFirstInitial = caretaker.fullName!.prefix(1)
                cell.familyMemberInitialLabel.text = "\(caretakerFirstInitial)"
                cell.familyMemberNameLabel.text = "\(caretaker.fullName!) (Parent)"
                return cell
            } else {
                let child: Child = AppData.shared.children[(indexPath.item - AppData.shared.caretakers.count)]
                var childFirstInitial = child.fullName!.prefix(1)
                cell.familyMemberInitialLabel.text = "\(childFirstInitial)"
                cell.familyMemberNameLabel.text = "\(child.fullName!) (Child)"
                
                return cell
            }
            
        } else {
            // Logout Section
            let cell: SettingsLogoutCell = tableView.dequeueReusableCell(withIdentifier: "settingsLogoutCell") as! SettingsLogoutCell
            cell.logoutLabel.text = "Logout"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 && indexPath.item == 0) {
            // Remove JWT
            let defaults = UserDefaults.standard
            defaults.setValue(nil, forKey: "jwt")
            
            // Clear Region Monitoring
            LocationService.shared.stopAllRegionMonitors()
            
            // Clear App Data
            AppData.shared.resetData()
            
            // Unregister Push Notifications
            UIApplication.shared.unregisterForRemoteNotifications()
            
            // Go back to Signup VC
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
            {
                print ("error 1");
                return
                
            }
            
            let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignupVC")
            appDelegate.window!.rootViewController = signupVC
            appDelegate.window!.makeKeyAndVisible()
            
        }
    }
    
    
}
