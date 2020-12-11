//
//  AddChildInfoVC.swift
//  Triage
//
//  Created by Tamer Bader on 6/7/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import MapKit

class AddChildInfoVC: UIViewController {

    @IBOutlet weak var fieldSuperView: UIView!
    @IBOutlet weak var innerFieldSuperView: UIView!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var addressTableBottomConstraint: NSLayoutConstraint!
    
    // Refresh Data Delegate
    var delegate: RefreshDelegateProtocol?
    
    // Progress Bar
    var progressBarValue: Float = 0
    var childId: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard Listener
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        // Setup initial view
        setupView()
        
        // Textfield Delegate
        infoTextField.delegate = self
        
        spinner.isHidden = true
                
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
        
        progressBar.progress = 0.20
        
        setupFieldView(field: Field(title: "Child's Name", subtitle: "Please enter the full name of your child", placeholder: "Enter Child's Name", contentType: .name, keyboardType: .namePhonePad, infoType: .FULL_NAME))

    }
    
    func registerChild(withName name: String) {
        APIAddChildRequest(fullName: name).dispatch(
            onSuccess: {(successResponse) in
                self.childId = successResponse.user_id
                
                self.performSegue(withIdentifier: "goToNickname", sender: nil)
                
            },
            onFailure: {(errorResponse, error) in
                self.hideSpinner()
                print(errorResponse ?? "error response")
                print(error)
            })
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideSpinner()
        let destVC: AddChildLocationNicknameVC = segue.destination as! AddChildLocationNicknameVC
        destVC.childId = self.childId
        destVC.delegate = self.delegate
    }
}

extension AddChildInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let name: String = infoTextField.text?.trimTrailingWhitespaces() else {return true}
        registerChild(withName: name)
        return true
    }
}
