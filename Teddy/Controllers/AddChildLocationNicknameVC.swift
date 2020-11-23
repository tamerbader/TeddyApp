//
//  AddChildLocationNicknameVC.swift
//  Triage
//
//  Created by Tamer Bader on 10/28/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

class AddChildLocationNicknameVC: UIViewController {

    @IBOutlet weak var fieldSuperView: UIView!
    @IBOutlet weak var innerFieldSuperView: UIView!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // Child
    var childId: String!
    
    // Dropoff Builder
    var dropoff: DropoffBuilder = DropoffBuilder()
    
    // Refresh Data Delegate
    var delegate: RefreshDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        setupView()
        
        // Setup Textfield Delegate
        infoTextField.delegate = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.shouldRefreshData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToAddress") {
            let destVC: AddChildAddressVC = segue.destination as! AddChildAddressVC
            destVC.childId = childId
            destVC.dropoff = dropoff
            destVC.delegate = delegate
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
        
        progressBar.progress = 0.40
        
        activityIndicator.isHidden = true
        
        setupFieldView(field: Field(title: "Child's Location Nickname", subtitle: "Please enter a nickname for the drop-off location. Ex. School, Daycare, Karate Class, etc.", placeholder: "Ex. School, Daycare, Karate Class", contentType: .name, keyboardType: .asciiCapable, infoType: .FULL_NAME))

    }
    
    // Field View Helper
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
    

}


// Textfield Extension

extension AddChildLocationNicknameVC: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nickname: String = infoTextField.text?.trimTrailingWhitespaces() else
        {
            return true
        }
        
        // Save Nickname and pass to next vc
        dropoff.nickname = nickname
        
        // Go to next screen
        performSegue(withIdentifier: "goToAddress", sender: nil)
        
        return true
    }
}
