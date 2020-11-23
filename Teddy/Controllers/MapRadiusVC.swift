//
//  MapRadiusVC.swift
//  Triage
//
//  Created by Tamer Bader on 3/7/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import MapKit

class MapRadiusVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // Child Information From Prev VC
    var childId: String!
    var dropoff: DropoffBuilder!
    
    // Map Setup
    var coordinates: CLLocationCoordinate2D!
    var mapRadius: Float = 300
    var overlays: [MKOverlay] = []
    
    // Refresh Data Delegate
    var delegate: RefreshDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the View Controller
        setupVC()
        
        // Setup The Map
        setupMapview()
        
        // Setup Geofencing
        addGeofencingCircle(radius: Float(mapRadius))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.shouldRefreshData()
    }
    
    @IBAction func radiusSliderValueChanged(_ sender: UISlider) {
        print("Slider value: \(sender.value)")
        mapRadius = sender.value
        addGeofencingCircle(radius: mapRadius)
    }
    
    func setupVC() {
        // MapView Delegate
        self.mapView.delegate = self
        
        // Slider Setup
        self.radiusSlider.setValue(Float(mapRadius), animated: true)
        
        // Next Button Setup
        self.nextButton.layer.cornerRadius = 10
        
        // Progress Bar Update
        self.progressBar.progress = 0.80
        
        
    }
    
    
    func setupMapview() {
        
        guard let location = dropoff.location else {
            return
        }
        
        // Draws the Map
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // Adds the Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Drop Off"
        mapView.addAnnotation(annotation)
    }
    
    func addGeofencingCircle(radius: Float) {
        guard let location = dropoff.location else {return}
        let circle: MKCircle = MKCircle(center: location, radius: Double(radius))
        
        DispatchQueue.main.async {
            self.mapView.addOverlay(circle)
            self.mapView.removeOverlays(self.overlays)
            self.overlays.append(circle)
        }
        

    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        dropoff.radius = Double(mapRadius)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToDropoffTimes", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDropoffTimes") {
            let destVC: AddChildDropoffTimeVC = segue.destination as! AddChildDropoffTimeVC
            destVC.dropoff = dropoff
            destVC.childId = childId
            destVC.flow = .ADDING
            destVC.delegate = self.delegate
        }
    }
}

extension MapRadiusVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKCircle) {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor.blue.withAlphaComponent(0.2)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
}
