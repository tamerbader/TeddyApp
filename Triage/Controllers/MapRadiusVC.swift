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
    @IBOutlet weak var radiusLabel: UILabel!
    
    var coordinates: CLLocationCoordinate2D!
    var mapRadius: Float = 200
    
    var overlays: [MKOverlay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the View Controller
        setupVC()
        
        // Setup The Map
        setupMapview()
        
        // Setup Geofencing
        addGeofencingCircle(radius: mapRadius)
        
    }
    
    @IBAction func radiusSliderValueChanged(_ sender: UISlider) {
        let currentRadiusValue: Int = Int(sender.value)
        radiusLabel.text = "Radius: \(currentRadiusValue)m"
        addGeofencingCircle(radius: Float(currentRadiusValue))
    }
    
    func setupVC() {
        // MapView Delegate
        self.mapView.delegate = self
        self.radiusSlider.setValue(mapRadius, animated: true)
        self.radiusLabel.text = "Radius: \(mapRadius)m"
    }
    
    
    func setupMapview() {
        
        guard let location = coordinates else {
            return
        }
        
        // Draws the Map
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // Adds the Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Drop Off"
        mapView.addAnnotation(annotation)
    }
    
    func addGeofencingCircle(radius: Float) {
        guard let location = coordinates else {return}
        let circle: MKCircle = MKCircle(center: location, radius: Double(radius))
        
        DispatchQueue.main.async {
            self.mapView.addOverlay(circle)
            self.mapView.removeOverlays(self.overlays)
            self.overlays.append(circle)
        }
        

    }
    
}

extension MapRadiusVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKCircle) {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor.blue.withAlphaComponent(0.5)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
}
