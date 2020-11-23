//
//  DropoffDetailVC.swift
//  Teddy
//
//  Created by Tamer Bader on 11/8/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import MapKit

class ChildDetailVC: UIViewController {
    
    // Navigation Bar
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var navigationBarButtonView: UIView!
    @IBOutlet weak var navigationBarButton: UIButton!
    @IBOutlet weak var navigationBarButtonImage: UIImageView!
    @IBOutlet weak var navigationBarTitleLabel: UILabel!
    
    // Map View
    @IBOutlet weak var mapView: MKMapView!
    
    // Drop-off Section
    @IBOutlet weak var dropoffsTitle: UILabel!
    @IBOutlet weak var dropoffsTable: UITableView!
    
    // Add Dropoff
    @IBOutlet weak var addDropoffView: UIView!
    @IBOutlet weak var addDropoffButton: UIButton!
    
    // Controller Data
    var child: Child!
    var selectedDropoff: Dropoff?
    
    // Delegate
    var delegate: RefreshDelegateProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Table View
        setupTableView()
        
        // Setup Map View
        setupMapView()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editDropoffTimes") {
            let destVC: AddChildDropoffTimeVC = segue.destination as! AddChildDropoffTimeVC
            destVC.flow = .EDITING
            destVC.cronTimes = selectedDropoff?.times
            destVC.dropoffId = selectedDropoff?._id
            destVC.delegate = self.delegate
        }
        
        if (segue.identifier == "addDropoffLocation") {
            let destVC: AddChildLocationNicknameVC = segue.destination as! AddChildLocationNicknameVC
            destVC.childId = child._id
            destVC.delegate = self.delegate
            
        }
    }
    
    func setupTableView() {
        dropoffsTable.delegate = self
        dropoffsTable.dataSource = self
        dropoffsTable.tableFooterView = UIView()
    }
    
    func setupMapView() {
        
        // Request User Current Location
        //LocationService.shared.requestLocation()
        
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsBuildings = true
        
        // Find Map Region Center Point
        var mapCenterPoint = CLLocationCoordinate2D()
        let currentLocation = AppData.shared.currentLocation
        if (currentLocation == nil) {
            guard let firstDropoffLocation: Dropoff = child.dropoffs[0] else { return }
            mapCenterPoint = CLLocationCoordinate2D(latitude: Double(firstDropoffLocation.latitude)!, longitude: Double(firstDropoffLocation.longitude)!)
            
        } else {
            mapCenterPoint = currentLocation!
        }
        
        // Draw The Map
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: mapCenterPoint, span: span)
        mapView.setRegion(region, animated: true)
        
        // Setup Annotations
        
        for dropoff in child.dropoffs {
            // Create annotation marker for each dropoff location
            let annotation: MKPointAnnotation = MKPointAnnotation()
            let dropoffCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(dropoff.latitude)!, longitude: Double(dropoff.longitude)!)
            annotation.coordinate = dropoffCoordinate
            annotation.title = dropoff.nickname
            
            mapView.addAnnotation(annotation)
        }
        
    }
    @IBAction func didTapAddLocation(_ sender: UIButton) {
        self.performSegue(withIdentifier: "addDropoffLocation", sender: nil)
    }
    
}

extension ChildDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return child.dropoffs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create the cell
        let cell: DropoffLocationNameCell = tableView.dequeueReusableCell(withIdentifier: "dropoffLocationNameCell") as! DropoffLocationNameCell
        
        // Find Dropoff associated with cell number
        let dropoff: Dropoff = child.dropoffs[indexPath.item]
        
        // Setup the cell with the dropoff information
        cell.setupCell(withDropoff: dropoff, atPosition: (indexPath.item + 1))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDropoff = child.dropoffs[indexPath.item]
        self.performSegue(withIdentifier: "editDropoffTimes", sender: nil)
        
    }
    
    
}
