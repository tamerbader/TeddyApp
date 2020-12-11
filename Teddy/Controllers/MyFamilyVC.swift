//
//  MyFamilyVC.swift
//  Triage
//
//  Created by Tamer Bader on 5/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class MyFamilyVC: UIViewController {
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var familyMembersTableVIew: UITableView!
    @IBOutlet weak var addFamilyMemberButton: UIButton!
    @IBOutlet weak var addFamilyMemberSuperView: UIView!
    
    var familyInfo: [User] = []
    var appData: AppData = AppData.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Table View
        self.familyMembersTableVIew.delegate = self
        self.familyMembersTableVIew.dataSource = self
        
        // Setup UI
        addFamilyMemberSuperView.layer.cornerRadius = 10

        // Refresh User Data
        
        APIGetFamilyRequest().dispatch(
            onSuccess: { (successResponse) in
                // Update App Data
                AppData.shared.saveFromFamilyResponse(familyResponse: successResponse)
                
                // Reload tableview
                DispatchQueue.main.async {
                    self.familyMembersTableVIew.reloadData()
                }
                
            },
            onFailure: {(errorResponse, error) in
                print("I'm scared. I dont have a guardian :(")
                print(errorResponse ?? "error response")
                print(error)
            })
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToPush", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToPush") {
            let destVC: PushNotificationVC = segue.destination as! PushNotificationVC
            destVC.flow = .SIGNUP
        }
    }
    
}

extension MyFamilyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (appData.caretakers.count + appData.children.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Reference numbers to arrange list from Caretakers -> Children
        let numberOfCaretakers = appData.caretakers.count
        let numberOfChildren = appData.children.count
        
        if (indexPath.item < numberOfCaretakers) {
            let cell: FamilyCell = tableView.dequeueReusableCell(withIdentifier: "familyMemberCell") as! FamilyCell
            
            // Set Cell info
            cell.profileNameLabel.text = appData.caretakers[indexPath.item].fullName
            cell.profileTitleLabel.text = "Parent"
            
            return cell
        } else if (indexPath.item >= numberOfCaretakers && indexPath.item < (numberOfCaretakers + numberOfChildren)) {
            let cell: FamilyCell = tableView.dequeueReusableCell(withIdentifier: "familyMemberCell") as! FamilyCell
            
            // Set Cell info
            cell.profileNameLabel.text = appData.children[indexPath.item - numberOfCaretakers].fullName
            cell.profileTitleLabel.text = "Child"
            
            return cell
        } else {
            let cell: AddFamilyCell = tableView.dequeueReusableCell(withIdentifier: "addFamilyCell") as! AddFamilyCell
            cell.delegate = self
            
            return cell
        }
            
            
            
     /*
        if (indexPath.item == (familyInfo.count)) {
            let cell: AddFamilyCell = tableView.dequeueReusableCell(withIdentifier: "addFamilyCell") as! AddFamilyCell
            
            cell.delegate = self
            
            return cell
        }
        
        
        let cell: FamilyCell = tableView.dequeueReusableCell(withIdentifier: "familyMemberCell") as! FamilyCell
        cell.profileNameLabel.text = familyInfo[indexPath.item].fullName
        if (familyInfo[indexPath.item] is Caretaker) {
            cell.profileTitleLabel.text = "Parent"
        }
        if (familyInfo[indexPath.item] is Child) {
            cell.profileTitleLabel.text = "Child"
        }
        
        return cell*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
}

extension MyFamilyVC: AddMemberCellDelegate {
    func didTapAdd() {
        print("Going to make a new family member")
        self.performSegue(withIdentifier: "goToMemberDecision", sender: nil)
    }
    
    
}
