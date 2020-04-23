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


class MapViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //set up Firebase ref
        ref = Database.database().reference();
        
        //remove all existing users from the map
        let all = self.mapView.annotations
        self.mapView.removeAnnotations(all)
        refHandle = ref.child("User").observe(DataEventType.value, with: {
            (snapshot) in
            //1. Decode the 'snapshot' (Firebase data) into an array of NSDictionary objects
            if let users = snapshot.value as? [NSDictionary] {
                var myUsers:[PeopleAnnotation] = [PeopleAnnotation]()
                for currUser in users {
                    if let lat = currUser["lat"] as? Double,
                        let long = currUser["long"] as? Double,
                        let uid = currUser["uid"] as? Int,
                        let supplyNumber = currUser["supplyNumber"] as? Int,
                        let supplyType = currUser["supplyType"] as? String,
                        let userType = currUser["type"] as? String,
                        let tel = currUser["tel"] as? Int,
                        let name = currUser["name"] as? String{
                        //2. Decode the array of dictionaries into an array of EggAnnotations
                        let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let user:PeopleAnnotation = PeopleAnnotation(coordinate: coord, id: uid, supplyNumber: supplyNumber, supplyType: supplyType, tel: tel, type: userType, name: name)
                        myUsers.append(user)
                        print("user\(uid) appended!")
                    } else {
                        print("decoding failed!")
                    }
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(myUsers)
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //center map on current location
        centerMap()
    }
    
    func centerMap() {
        let coord = CLLocationCoordinate2D(latitude: 39.95189, longitude: -75.193775)
        let regionRadius: CLLocationDistance = 2000
        
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "PeopleAnnotationIdentifier"
        guard let currAnno = annotation as? PeopleAnnotation else { return nil }
        let annotationView: MKAnnotationView?
        //Try to dequeue an Annotation view with the identifier
        //   - If successful, just update the annotation
        //   - If unsuccessful, make a new MKAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeuedView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        //2. Configure the callout view
        if let annotationView = annotationView {
            if(currAnno.supplyType == "toilet paper") {
            annotationView.image = UIImage(named: "paper") as UIImage?
            } else if(currAnno.supplyType == "syringe") {
            annotationView.image = UIImage(named: "syringe") as UIImage?
            } else if(currAnno.supplyType == "mask") {
            annotationView.image = UIImage(named: "mask") as UIImage?
            } else {
            annotationView.image = UIImage(named: "user") as UIImage?
            }
            
            annotationView.canShowCallout = true
            let label = getCalloutLabel(name: currAnno.name, userType: currAnno.userType, supplyType: currAnno.supplyType, amount: currAnno.supplyNumber)
            annotationView.detailCalloutAccessoryView = label
            let button = getCalloutButton()
            annotationView.rightCalloutAccessoryView = button
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        if let button = view.rightCalloutAccessoryView as? UIButton {
            if let currAnnotation = view.annotation as? PeopleAnnotation {
                
                // TODO:
                //1.Toggle state of the egg annotation
                //2.Update the button with the correct title
                //3.Update the firebase database with the new `isCollected` value
                view.rightCalloutAccessoryView = button
            }
        }
    }
    
    
    
    // This function should not require modification
    private func getCalloutLabel(name: String, userType: String, supplyType: String, amount: Int) -> UILabel {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "\(name): \(userType)\n#\(supplyType): \(amount)"
        
        
        return label
    }
    
    // This function should not require modification
    private func getCalloutButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Contact", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        return button
    }
}




