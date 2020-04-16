//
//  MapViewController.swift
//  iDonate
//
//  Created by Qingyuan Peng on 4/15/20.
//  Copyright © 2020 pqy. All rights reserved.
//


import UIKit
import MapKit
import Firebase


class MapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
//    var ref: DatabaseReference!
//    var refHandle: DatabaseHandle!
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //set up Firebase ref
//        ref = Database.database().reference();
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnPennCampus()
    }
    
    func centerMapOnPennCampus() {
        let coord = CLLocationCoordinate2D(latitude: 39.95189, longitude: -75.193775)
        let regionRadius: CLLocationDistance = 2000
        
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}


