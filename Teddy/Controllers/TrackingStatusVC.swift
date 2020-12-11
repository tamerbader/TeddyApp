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
    @IBOutlet weak var addParentView: UIView!
    @IBOutlet weak var addChildView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addChildBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addParentBottomConstraint: NSLayoutConstraint!
    
    var isShowingButtonMenu: Bool = false
    
    var selectedChild: Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
        reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToAddChild") {
            let destNC: UINavigationController = segue.destination as! UINavigationController
            let destVC: AddChildInfoVC = destNC.topViewController as! AddChildInfoVC
            destVC.delegate = self
        }
        
        if (segue.identifier == "goToChildDetailVC") {
            let destVC: ChildDetailVC = segue.destination as! ChildDetailVC
            destVC.child = selectedChild
            destVC.delegate = self
        }
        
        if (segue.identifier == "goToPushNotification") {
            let destVC: PushNotificationVC = segue.destination as! PushNotificationVC
            destVC.flow = .HOME
        }
    }
    
    func reloadData() {
        setupLoadingDisplay()
        
        // Update the family data
        APIGetFamilyRequest().dispatch(
            onSuccess: {(successResponse) in
                AppData.shared.saveFromFamilyResponse(familyResponse: successResponse)
                
                DispatchQueue.main.async {
                    self.configureViewAfterDataRetrieval()
                    self.setupLocationService()
                    self.setupViewingDisplay()
                }
                
            },
            onFailure: {(errorResponse, error) in
                print("I'm scared. I dont have a guardian :(")
                print(errorResponse ?? "error response")
                print(error)
            })
    }
    
    func setupLoadingDisplay() {
        self.statusView.isHidden = true
        self.memberTable.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func setupViewingDisplay() {
        self.statusView.isHidden = false
        self.memberTable.isHidden = false
        self.memberTable.reloadData()
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func setupLocationService() {
        // Enable Location Services
        LocationService.shared.startLocationService()
        
        // Stop all active region monitors to reset
        LocationService.shared.stopAllRegionMonitors()
        
        // Start Tracking All Children
        for child in AppData.shared.children {
        }
    }
    
    func configureViewAfterDataRetrieval() {
        var isTrackingEnabled: Bool = true
        // First Check Location Services. If not enabled for always, present an alert to configure.
        if (!LocationService.shared.isAlwaysAuthorized()) {
            // Present an alert regarding updating location settings
            isTrackingEnabled = false
        }
        
        // Check to see if there's atleast 1 kid registered. If not then show an empty screen saying add child.
        if (!(AppData.shared.children.count > 0)) {
            // Present an empty screen informing user to add
            isTrackingEnabled = false
        }
        
        if (!UIApplication.shared.isRegisteredForRemoteNotifications) {
            isTrackingEnabled = false
        }
        
        if (isTrackingEnabled) {
            self.isStatusBarEnabled(status: .ENABLED)
        } else {
            self.isStatusBarEnabled(status: .DISABLED)
        }
        
    }
    
    @IBAction func didTapStatusBar(_ sender: UIButton) {
        if (!LocationService.shared.isAlwaysAuthorized()) {
            // Present an alert regarding updating location settings
            let locationServiceAlertController = UIAlertController(title: "Location Services Alert", message: "The application needs 'Always Authorized' permission to function properly. Please tap 'Fix' to continue", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                print("Cancel")
            })
            let fixAction = UIAlertAction(title: "Fix", style: .default, handler: { (action: UIAlertAction) in
                print("Going to fix")
                self.performSegue(withIdentifier: "goToLocationPermission", sender: nil)
            })
            
            locationServiceAlertController.addAction(cancelAction)
            locationServiceAlertController.addAction(fixAction)
            locationServiceAlertController.preferredAction = fixAction
            self.present(locationServiceAlertController, animated: true, completion: nil)
            return
        }
        
        if (!(AppData.shared.children.count > 0)) {
            let childrenAlertController = UIAlertController(title: "No Children Added", message: "Please add atleast 1 child in order for the app to begin working", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            childrenAlertController.addAction(okAction)
            self.present(childrenAlertController, animated: true, completion: nil)
            return

        }
        
        if (!UIApplication.shared.isRegisteredForRemoteNotifications) {
            // Create alert asking user to fix notification settings
            let notificationAlertController = UIAlertController(title: "Notification Service Alert", message: "The application will need push notification permissions in order to alert you. Please tap 'Fix' to continue", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                print("Cancel")
            }
            
            let fixAction = UIAlertAction(title: "Fix", style: .default) { (action) in
                self.performSegue(withIdentifier: "goToPushNotification", sender: nil)
            }
            
            notificationAlertController.addAction(cancelAction)
            notificationAlertController.addAction(fixAction)
            notificationAlertController.preferredAction = fixAction
            
            self.present(notificationAlertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func didTapAddMember(_ sender: UIButton) {
      /*  self.performSegue(withIdentifier: "trackingToAddMember", sender: nil)*/
        if (isShowingButtonMenu) {
            hideAddMemberSelections()
            isShowingButtonMenu = false
        } else {
            showAddMemberSelections()
            isShowingButtonMenu = true
        }
    }
    @IBAction func didTapAddChild(_ sender: UIButton) {
        AppData.shared.currentFlow = .MAINPAGE
        self.performSegue(withIdentifier: "goToAddChild", sender: nil)
        isShowingButtonMenu = false
        hideAddMemberSelections()
    }
    
    @IBAction func didTapAddParent(_ sender: UIButton) {
        let textToShare = "\(AppData.shared.currentUser.fullName!) invites you to join Teddy Bear! You can download the app from this link. \(AppData.shared.currentUser.familyID!) is your code to join the family!"
         
        if let myWebsite = NSURL(string: "\(ApplicationProperties.appShareLink)") {
                let objectsToShare = [textToShare, myWebsite] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
         
                activityVC.popoverPresentationController?.sourceView = sender
                self.present(activityVC, animated: true, completion: nil)
            }
        
        isShowingButtonMenu = false
        hideAddMemberSelections()
    }
    
    @IBAction func didTapSettings(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSettings", sender: nil)
    }
    
    func setupView() {
        // Set Flow
        AppData.shared.currentFlow = .MAINPAGE
        
        // Setup TableView
        memberTable.delegate = self
        memberTable.dataSource = self
        memberTable.allowsSelection = true
        memberTable.tableFooterView = UIView()
        
        // Setting up views
        self.addMemberView.layer.cornerRadius = self.addMemberView.frame.height/2
        self.addMemberView.backgroundColor = UIColor.teddy_blue
        
        // Initialize Member Buttons
        self.addParentView.layer.opacity = 0
        self.addChildView.layer.opacity = 0
        self.addParentView.layer.cornerRadius = 5
        self.addChildView.layer.cornerRadius = 5
        self.addParentView.layer.backgroundColor = UIColor.teddy_blue.cgColor
        self.addChildView.layer.backgroundColor = UIColor.teddy_blue.cgColor
        self.addParentView.layer.borderColor = UIColor.teddy_blue.cgColor
        self.addChildView.layer.borderColor = UIColor.teddy_blue.cgColor
        self.addChildView.layer.borderWidth = 2
        self.addParentView.layer.borderWidth = 2
        self.addParentBottomConstraint.constant = 0
        self.addChildBottomConstraint.constant = 0
    }
    
    func hideAddMemberSelections() {
        // Have Views Hidden (Maybe not necessary?)
       /* addParentView.isHidden = true
        addChildView.isHidden = true*/
        
        UIView.animate(withDuration: 0.3, animations: {
            // Set the opacity of the views.
            self.addParentView.layer.opacity = 0
            self.addChildView.layer.opacity = 0
            
            // Move the views on top of the add button
            self.addChildBottomConstraint.constant = 0
            self.addParentBottomConstraint.constant = 0
            
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    func showAddMemberSelections() {
        // Have Views Hidden (Maybe not necessary?)
       /* addParentView.isHidden = true
        addChildView.isHidden = true*/
        
        UIView.animate(withDuration: 0.3, animations: {
            // Set the opacity of the views.
            self.addParentView.layer.opacity = 1
            self.addChildView.layer.opacity = 1
            
            // Move the views on top of the add button
            self.addChildBottomConstraint.constant = -20
            self.addParentBottomConstraint.constant = (-20 - (self.addChildView.frame.height) - 10)
            
            self.view.layoutIfNeeded()

        })
        
        
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
extension TrackingStatusVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (AppData.shared.children.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackingStatusCell = tableView.dequeueReusableCell(withIdentifier: "trackingStatusCell") as! TrackingStatusCell
        
        let currentChild: Child = AppData.shared.children[indexPath.item]
        
        // Cell Color
        if (indexPath.item == 0) {
            cell.circleView.backgroundColor = UIColor.firstChildColor
        } else if (indexPath.item == 1) {
            cell.circleView.backgroundColor = UIColor.secondChildColor
        } else if (indexPath.item == 2) {
            cell.circleView.backgroundColor = UIColor.thirdChildColor
        } else if (indexPath.item == 3) {
            cell.circleView.backgroundColor = UIColor.fourthChildColor
        } else if (indexPath.item == 4) {
            cell.circleView.backgroundColor = UIColor.fifthChildColor
        } else {
            cell.circleView.backgroundColor = UIColor.firstChildColor
        }
        
        let childName = currentChild.fullName!
        let firstChar = childName.prefix(1)
        
        cell.childInitialLabel.text = "\(firstChar)"
        cell.nameLabel.text = "\(currentChild.fullName!)"
        
        if (currentChild.nextDropoff._id == "") {
            cell.dropoffReminderLabel.text = "No Drop-offs Scheduled Yet"
        } else {
            cell.dropoffReminderLabel.text = "Next Drop-off: \(currentChild.nextDropoff.nickname) - \(currentChild.nextDropoff.time)"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Segue to Child Detail VC passing along the child at the id indexPath.item
        selectedChild = AppData.shared.children[indexPath.item]
        
        self.performSegue(withIdentifier: "goToChildDetailVC", sender: nil)
        
    }
    
    
}

extension TrackingStatusVC: RefreshDelegateProtocol {
    func shouldRefreshData() {
        print("Reloading Data")
        reloadData()
    }
    
    
}
