//
//  AddChildDropoffTimeVC.swift
//  Triage
//
//  Created by Tamer Bader on 8/9/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import BonsaiController

class AddChildDropoffTimeVC: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dropoffTimeTable: UITableView!
    @IBOutlet weak var addTimeButton: UIButton!
    @IBOutlet var addButtonBottomConstraint: NSLayoutConstraint!
    
    var childId: String!
    var dropoff: DropoffBuilder!
    var dropoffTimes: [DropoffTime] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()

    }
    @IBAction func didTapAdd(_ sender: UIButton) {
        var cronTimes: [String] = []
        for dropoffTime in dropoffTimes {
            let currentDropoffCronTimes: [String] = dropoffTime.convertDropoffTimeToCronTime()
            cronTimes.append(contentsOf: currentDropoffCronTimes)
        }
        
        // Make API Request To Update Dropoff Times
        APIAddDropoffRequest(childId: childId, latitude: String(dropoff.location!.latitude), longitude: String(dropoff.location!.longitude), radius: "\(dropoff.radius!)", times: cronTimes).dispatch(
            onSuccess: {
                
                DispatchQueue.main.async {
                    guard let currentFlow = AppData.shared.currentFlow else {return}
                    if (currentFlow == .SIGNUP) {
                        self.performSegue(withIdentifier: "goToFamily", sender: nil)
                    } else if (currentFlow == .MAINPAGE) {
                        self.performSegue(withIdentifier: "goToTrackingStatus", sender: nil)
                    }
                }
                
            }, onFailure: { (errorResponse, error) in
                print(errorResponse)
                print(error)
                
            })
        /*
        APIUpdateDropoffTimeRequest(times: cronTimes, childId: child._id!).dispatch(onSuccess: {
            print("We successfully updated the dropoff times. LET'S GOOO")
            DispatchQueue.main.async {
                guard let currentFlow = AppData.shared.currentFlow else {return}
                if (currentFlow == .SIGNUP) {
                    self.performSegue(withIdentifier: "goToFamily", sender: nil)
                } else if (currentFlow == .MAINPAGE) {
                    self.performSegue(withIdentifier: "goToTrackingStatus", sender: nil)
                }
            }
        }, onFailure: { (errorResponse, error) in
            print("Fuck no dropoff :(")
        })
        */
        
        
        
    }
    
    func setupVC() {
        
        // Setting up the tableview
        self.dropoffTimeTable.delegate = self
        self.dropoffTimeTable.dataSource = self
        reloadTableData()
        
        // UI Setup
        self.addTimeButton.layer.cornerRadius = 10
    }
    
    func showPopup() {
        // Instantiate View Controller
        let timeVC: AddTimePopupVC = storyboard!.instantiateViewController(withIdentifier: "selectTimeVC") as! AddTimePopupVC
        
        // Setting up VC to take custom animation for entrance
        timeVC.transitioningDelegate = self
        timeVC.modalPresentationStyle = .custom
        timeVC.delegate = self
        
        // Display VC
        present(timeVC, animated: true, completion: nil)
    }
    
    func reloadTableData() {
        self.dropoffTimeTable.reloadData()
    }
}

extension AddChildDropoffTimeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropoffTimes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.item == (dropoffTimes.count)) {
            let cell: AddFamilyCell = tableView.dequeueReusableCell(withIdentifier: "addFamilyCell") as! AddFamilyCell
            cell.delegate = self
            return cell
        }
        
        let cell: DropoffTimeCell = tableView.dequeueReusableCell(withIdentifier: "dropoffTimesCell") as! DropoffTimeCell
        let dropoffTime: DropoffTime = dropoffTimes[indexPath.item]
        
        // Cell Contents
        cell.timeLabel.text = dropoffTime.date.displayTimeFormat()
        cell.daysLabel.text = dropoffTime.convertDaysToDisplayString()
        
        // Cell UI
        cell.marker.backgroundColor = UIColor.red
        cell.containerView.layer.masksToBounds = true
        cell.containerView.layer.cornerRadius = 5
        cell.containerView.layer.borderColor = UIColor.lightGray.cgColor
        cell.containerView.layer.borderWidth = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

extension AddChildDropoffTimeVC: BonsaiControllerDelegate {
    
    // return the frame of your Bonsai View Controller
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: containerViewFrame.height / 4), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (1)))
    }
    
    // return a Bonsai Controller with SlideIn or Bubble transition animator
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    
        /// With Background Color ///
    
        // Slide animation from .left, .right, .top, .bottom
        return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, backgroundColor: UIColor(white: 0, alpha: 0.5), presentedViewController: presented, delegate: self)
    
    
        /// With Blur Style ///
        
        // Slide animation from .left, .right, .top, .bottom
        //return BonsaiController(fromDirection: .bottom, blurEffectStyle: .regular, presentedViewController: presented, delegate: self)
        
        // or Bubble animation initiated from a view
        //return BonsaiController(fromView: yourOriginView, blurEffectStyle: .dark,  presentedViewController: presented, delegate: self)
    }
}

extension AddChildDropoffTimeVC: DropoffTimeDelegate {
    func didAddDropoffTime(time: DropoffTime) {
        self.dropoffTimes.append(time)
        self.reloadTableData()
    }
    
}

extension AddChildDropoffTimeVC: AddMemberCellDelegate {
    func didTapAdd() {
        // Show time choices popup
        showPopup()
    }
    
    
}

protocol DropoffTimeDelegate: class {
    func didAddDropoffTime(time: DropoffTime)
}
