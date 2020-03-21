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
    
    var coordinates: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
          // 1
          let location = coordinates
          
          // 2
          let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
          let region = MKCoordinateRegion(center: location!, span: span)
              mapView.setRegion(region, animated: true)
              
          //3
          let annotation = MKPointAnnotation()
          annotation.coordinate = location!
          annotation.title = "Panera"
          mapView.addAnnotation(annotation)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
