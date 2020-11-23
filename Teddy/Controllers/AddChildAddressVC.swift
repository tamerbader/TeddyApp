//
//  AddChildInfoVC.swift
//  Triage
//
//  Created by Tamer Bader on 6/7/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import MapKit

class AddChildAddressVC: UIViewController {

    @IBOutlet weak var fieldSuperView: UIView!
    @IBOutlet weak var innerFieldSuperView: UIView!
    @IBOutlet weak var addressTable: UITableView!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addressTableBottomConstraint: NSLayoutConstraint!
    
    

    // AutoComplete Location Search
    lazy var searchCompleter: MKLocalSearchCompleter = {
    let sC = MKLocalSearchCompleter()
    sC.delegate = self
    sC.filterType = .locationsOnly
    return sC
    }()
    var searchSource: [MKLocalSearchCompletion]?
    var locatedPOICoordinate: CLLocationCoordinate2D?
    
    //Child
    var childId: String!
    
    // Dropoff Builder
    var dropoff: DropoffBuilder!
    
    // Progress Bar
    var currentSetupProgress: ChildInfoSetup = .None
    var progressBarValue: Float = 0
    
    // Refresh Data Delegate
    var delegate: RefreshDelegateProtocol?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard Listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        // Setup initial view
        setupView()
       
        // Setup tableview delegate
        addressTable.delegate = self
        addressTable.dataSource = self
        
        // Textfield Delegate
        infoTextField.delegate = self
        


        spinner.isHidden = true
                
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.shouldRefreshData()
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {

        if let userInfo = notification.userInfo {

            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue

            let isKeyboardShowing = notification.name == UIResponder.keyboardDidShowNotification

            addressTableBottomConstraint?.constant = isKeyboardShowing ? keyboardFrame!.height : 0

            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func setupView() {
        // Setup View
        fieldSuperView.layer.cornerRadius = 8
        fieldSuperView.layer.borderWidth = 3
        fieldSuperView.layer.borderColor = UIColor(displayP3Red: 0.935, green: 0.915, blue: 0.991, alpha: 1).cgColor

        innerFieldSuperView.layer.cornerRadius = 4
        innerFieldSuperView.layer.borderWidth = 1
        innerFieldSuperView.layer.borderColor = UIColor.blue.cgColor
        
        self.progressBar.progress = 0.6
        
        setupFieldView(field: Field(title: "Child's Location", subtitle: "Please enter the school/daycare that you drop off your child", placeholder: "Enter Dropoff Location", contentType: .fullStreetAddress, keyboardType: .numbersAndPunctuation, infoType: .FULL_NAME))
    }
    
    func setupFieldView(field: Field) {
        self.titleLabel.text = field.title
        if ((field.subtitle) != nil) {
            self.subtitleLabel.text = field.subtitle
        }
        self.infoTextField.placeholder = field.placeholder
        self.infoTextField.textContentType = field.contentType
        self.infoTextField.keyboardType = field.keyboardType
        self.infoTextField.reloadInputViews()
        infoTextField.becomeFirstResponder()
    }
    
    
    func hideSpinner() {
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    func showSpinner() {
        self.spinner.startAnimating()
        self.spinner.isHidden = false
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard let fieldText: String = infoTextField.text else {return}
        
        if (!fieldText.isEmpty) {
            addressTable.isHidden = false
            searchCompleter.queryFragment = infoTextField.text!
        }
    }
    /* @IBAction func tetFieldEditingDidChange(_ sender: UITextField) {
        guard let fieldText: String = infoTextField.text else {return}
        
        if (!fieldText.isEmpty) {
            addressTable.isHidden = false
            searchCompleter.queryFragment = infoTextField.text!
        }
    } */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideSpinner()
        let destVC: MapRadiusVC = segue.destination as! MapRadiusVC
        destVC.dropoff = dropoff
        destVC.childId = childId
        destVC.delegate = self.delegate
    }
}

extension AddChildAddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        LocationServices.convertAddressToCoordinate(address: infoTextField.text!, completionHandler: { (result, err) in
            self.locatedPOICoordinate = result?.coordinate
            
            // Saving New Child's DropOff Location
            self.dropoff.location = result?.coordinate
            self.dropoff.name = result?.description

            self.performSegue(withIdentifier: "goToMap", sender: nil)
        })
            
        return true
    }
}

extension AddChildAddressVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AutoCompleteAddressCell = tableView.dequeueReusableCell(withIdentifier: "autocompleteAddressCell") as! AutoCompleteAddressCell
        cell.addressLabel.text = self.searchSource?[indexPath.row].title
        cell.addressSubtitle.text = self.searchSource?[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showSpinner()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "\(self.searchSource![indexPath.row].title) \(self.searchSource![indexPath.row].title)"
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { (response, error) in
            guard let response = response else {return}
            if (response.mapItems.count > 0) {
                self.locatedPOICoordinate = response.mapItems[0].placemark.coordinate
                
                // Saving New Child's DropOff Location
                self.dropoff.location = response.mapItems[0].placemark.coordinate
                self.dropoff.name = response.mapItems[0].placemark.title
                self.performSegue(withIdentifier: "goToMap", sender: nil)
            } else {
                return
            }
        })
    }
    
    
}

enum ChildInfoSetup {
    case None
    case Name
    case Location
}

extension AddChildAddressVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchSource = completer.results
        DispatchQueue.main.async {
            self.addressTable.reloadData()
        }
    }
}
