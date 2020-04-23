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
    var userType: String = ""
    var supplyType: String = "none"
    var supplyAmount: Int = 0
    var currId: Int = 0
    
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //set up Firebase ref
        ref = Database.database().reference();
        
        refHandle = ref.child("User").observe(DataEventType.value, with: {
            (snapshot) in
            //remove all existing users from the map
            //let all = self.mapView.annotations
            //self.mapView.removeAnnotations(all)
            //Decode the 'snapshot' (Firebase data) into an array of NSDictionary objects
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
                    } else {
                        print("decoding failed!")
                    }
                }
                DispatchQueue.main.async {
                    let all = self.mapView.annotations
                    self.mapView.removeAnnotations(all)
                    self.mapView.addAnnotations(myUsers)
                    self.updateLabel()
                }
            }
        })
    }
    
    func updateLabel() {
        //set status label
        if(userType == "seeker") {
            if(supplyAmount == 0) {
                statusLabel.text = "Congrats! You find all the supplies you need!"
            } else {
            statusLabel.text = "Hi \(userType), you currently need \(supplyAmount)  \(supplyType). Good luck!"
            }
        } else if(userType == "donor"){
            statusLabel.text = "Hi \(userType), you currently have \(supplyAmount)  \(supplyType) to donate. Thanks for helping :)"
        } else {
            statusLabel.text = "Hi, you are currently a viewer, please go back and enter your information."
        }
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
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView = dequeuedView
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        //2. Configure the callout view
        if let annotationView = annotationView {
            if(currAnno.id == currId) {
            annotationView.image = UIImage(named: "self") as UIImage?
            }
            else if(currAnno.supplyType == "toilet paper") {
            annotationView.image = UIImage(named: "paper") as UIImage?
            } else if(currAnno.supplyType == "syringe") {
            annotationView.image = UIImage(named: "syringe") as UIImage?
            } else if(currAnno.supplyType == "mask") {
            annotationView.image = UIImage(named: "mask") as UIImage?
            } else {
            annotationView.image = UIImage(named: "user") as UIImage?
            }
            
            annotationView.canShowCallout = true
            let button = getCalloutButton()
            annotationView.rightCalloutAccessoryView = button
            let label = getCalloutLabel(name: currAnno.name, userType: currAnno.userType, supplyType: currAnno.supplyType, amount: currAnno.supplyNumber, tel: currAnno.tel)
            annotationView.detailCalloutAccessoryView = label
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let button = view.rightCalloutAccessoryView as? UIButton {
            if let target = view.annotation as? PeopleAnnotation {
                
                view.rightCalloutAccessoryView = button
                if(supplyType == target.supplyType && supplyAmount > 0 &&
                    ((userType == "donor" && target.userType == "seeker") || (userType == "seeker" && target.userType == "donor"))) {
                    if(supplyAmount > target.supplyNumber) {
                    supplyAmount = supplyAmount - target.supplyNumber
                    target.supplyNumber = 0
                    } else {
                    target.supplyNumber = target.supplyNumber - supplyAmount
                    supplyAmount = 0
                        print("target have: \(target.supplyNumber)" )
                    }
                } else {
                    button.setTitle("unavaliable", for: .disabled)
                }
                
                ref.child("User").child(String(currId)).updateChildValues(["supplyNumber": self.supplyAmount])
                ref.child("User").child(String(target.id)).updateChildValues(["supplyNumber": target.supplyNumber])
                //self.updateLabel()
                print("I currently have: \(self.supplyAmount)" )
                print("after if target have: \(target.supplyNumber)" )
            }
        }
    }
    
    private func getCalloutLabel(name: String, userType: String, supplyType: String, amount: Int, tel: Int) -> UILabel {
        let label = UILabel()
        //label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        if(userType == "donor") {
            label.text = "\(name)(\(userType))\nhas \(amount) \(supplyType) to donate. \ntel: \(tel)"
        } else {
            label.text = "\(name)(\(userType))\nneeds \(amount) \(supplyType). \ntel: \(tel)"
        }
        return label
    }
    
    // This function should not require modification
    private func getCalloutButton() -> UIButton {
        let button = UIButton(type: .system)
        if(userType == "donor") {
        button.setTitle("Donate", for: .normal)
        } else if(userType == "seeker") {
        button.setTitle("Get", for: .normal)
        } else {
            button.setTitle("unavaliable", for: .disabled)
        }
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10.0
        button.tintColor = .white
        button.frame = CGRect.init(x: 0, y: 0, width: 100, height: 50)
        return button
    }
}




