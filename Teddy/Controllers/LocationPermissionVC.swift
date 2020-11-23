//
//  LocationPermissionVC.swift
//  Triage
//
//  Created by Tamer Bader on 10/21/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changePermissionButton: UIButton!
    @IBOutlet weak var changePermissionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        
    }
    
    func setupVC() {
        // Setup the UI
        setupUI()
        
        // Setup Foreground Enter Notification
        setupNotifications()
    }
    
    func setupUI() {
        // Change Button
        changePermissionView.layer.cornerRadius = 20
        
        // ImageView
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        // Setup GIF
        setupGif()
        
    }
    
    func setupGifT() {
        let gifURL : String = "https://media.giphy.com/media/1EAQvbNkOF63pIIaZL/giphy.gif"
        let imageURL = UIImage.gifImageWithURL(gifURL)

        imageView.image = imageURL
    }
    
    func setupGif() {
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "setup", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        
        imageView.image = advTimeGif
    }
    
    func setupNotifications()  {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(appMovedToForeground),
            name:UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
    }
    
    
    @IBAction func didTapChange(_ sender: UIButton) {
        if let bundleId = Bundle.main.bundleIdentifier,
           let url = URL(string: "\(UIApplication.openSettingsURLString)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func appMovedToForeground() {
        if (LocationService.shared.isAlwaysAuthorized()) {
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
    }
    
        
}
