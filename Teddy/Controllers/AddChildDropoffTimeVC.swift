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
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var navigationBarTitle: UILabel!
    @IBOutlet weak var dividerView: UIView!
    
    // Current Flow
    var flow: DropoffTimeFlow!
    
    // Adding New Dropoff
    var childId: String?
    var dropoff: DropoffBuilder?
    
    // Editing Dropoff Times
    var dropoffId: String?
    var cronTimes: [String]?
    var selectedDropoffTime: DropoffTime?
    var dropoffNickname: String?
    
    // Dropoff Times
    var dropoffTimes: [DropoffTime] = []
    
    // Refresh Data Delegate
    var delegate: RefreshDelegateProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.shouldRefreshData()
    }
    
    @IBAction func didTapAdd(_ sender: UIButton) {
        var cronTimes: [String] = []
        for dropoffTime in dropoffTimes {
            let currentDropoffCronTimes: [String] = dropoffTime.convertDropoffTimeToCronTime()
            cronTimes.append(contentsOf: currentDropoffCronTimes)
        }
        
        switch flow! {
        case .ADDING:
            // Make API Request To Update Dropoff Times
            guard let childId: String = childId else { return }
            guard let dropoff: DropoffBuilder = dropoff else { return }
            // Make API Request To Update Dropoff Times
            APIAddDropoffRequest(childId: childId, latitude: String(dropoff.location!.latitude), longitude: String(dropoff.location!.longitude), nickname: "\(dropoff.nickname!)", radius: "\(dropoff.radius!)", times: cronTimes).dispatch(
                onSuccess: {
                    
                    DispatchQueue.main.async {
                        guard let currentFlow = AppData.shared.currentFlow else {return}
                        self.delegate?.shouldRefreshData()
                        if (currentFlow == .SIGNUP) {
                            self.performSegue(withIdentifier: "goToFamily", sender: nil)
                        } else if (currentFlow == .MAINPAGE) {
                            //self.performSegue(withIdentifier: "goToTrackingStatus", sender: nil)
                            
                            self.navigationController?.dismiss(animated: true, completion: {
                                
                            })
                            
                            self.navigationController?.popToRootViewController(animated: true)
                            self.delegate?.shouldRefreshData()

                        }
                    }
                    
                }, onFailure: { (errorResponse, error) in
                    print(errorResponse ?? "error response")
                    print(error)
                    
                })
        case .EDITING:
            print("Hitting edit dropoff endpoint")
            
            guard let dropoffId: String = dropoffId else { return }
            
            // Make API Update Dropoff Time Request
            APIUpdateDropoffTimeRequest(times: cronTimes, dropoffId: dropoffId).dispatch(
                onSuccess: {
                    print("Update Times Successful")
                    
                    
                    DispatchQueue.main.async {
                        guard let currentFlow = AppData.shared.currentFlow else {return}
                        self.delegate?.shouldRefreshData()
                        if (currentFlow == .SIGNUP) {
                            self.performSegue(withIdentifier: "goToFamily", sender: nil)
                        } else if (currentFlow == .MAINPAGE) {
                            self.navigationController?.dismiss(animated: true, completion: {
                                
                            })
                            self.delegate?.shouldRefreshData()
                            self.navigationController?.popToRootViewController(animated: true)

                        }
                    }
                }, onFailure: { (error, err) in
                    print("WE GOT AN ERROR")
                    
                })
        
        
        
        }
        
        
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.shouldRefreshData()
    }
    
    func setupVC() {
        
        switch flow! {
            case .ADDING:
                self.addTimeButton.setTitle("Next", for: .normal)
                self.navigationBarTitle.text = "Add a Child"
                self.progressBar.isHidden = false
                self.dividerView.isHidden = true
            case .EDITING:
                self.addTimeButton.setTitle("Save", for: .normal)
                self.navigationBarTitle.text = "Edit Drop-off Times"
                self.headerLabel.text = "\(dropoffNickname!) Drop-off Times"
                self.progressBar.isHidden = true
                self.dividerView.isHidden = false
                guard let times: [String] = cronTimes else {return}
                dropoffTimes = DropoffTime.createFromCronTimes(cronTimes: times)
        }
        
        // UI Setup
        self.addTimeButton.layer.cornerRadius = 10
        
        // Progress Bar Update
        progressBar.progress = 1.0
        
        // Setting up the tableview
        self.dropoffTimeTable.delegate = self
        self.dropoffTimeTable.dataSource = self
        reloadTableData()
        

        
    }
    
    func showPopup(withEditing: Bool = false) {
        // Instantiate View Controller
        let timeVC: AddTimePopupVC = storyboard!.instantiateViewController(withIdentifier: "selectTimeVC") as! AddTimePopupVC
        
        // Setting up VC to take custom animation for entrance
        timeVC.transitioningDelegate = self
        timeVC.modalPresentationStyle = .custom
        timeVC.delegate = self
        
        if (withEditing) {
            timeVC.isEditingSelection = true
            timeVC.currentDropoffTime = selectedDropoffTime!
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           selectedDropoffTime = dropoffTimes[indexPath.item]
        showPopup(withEditing: true)
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
    func didEditDropoffTime(time: DropoffTime, originalTime: DropoffTime) {
        var index = dropoffTimes.firstIndex(where: { (obj) -> Bool in
            return obj.time == originalTime.time
        })
        guard let dropoffTimeIndex: Array<DropoffTime>.Index = index else {return}
        dropoffTimes.remove(at: dropoffTimeIndex)
        dropoffTimes.append(time)
        
        self.reloadTableData()

    }
     
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
    func didAddDropoffTime(time: DropoffTime )
    func didEditDropoffTime(time: DropoffTime, originalTime: DropoffTime)
}

enum DropoffTimeFlow {
    case ADDING
    case EDITING
}
