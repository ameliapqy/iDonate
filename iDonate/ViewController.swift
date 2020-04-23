//
//  ViewController.swift
//  iDonate
//
//  Created by Qingyuan Peng on 4/12/20.
//  Copyright © 2020 pqy. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet var userField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var signUpButton: UIButton!

    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var userCount:Int = 0
    //let locationManager = CCLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userField.layer.cornerRadius = 10.0
        signUpButton.layer.cornerRadius = 10.0
        nameField.layer.cornerRadius = 10.0
        
        ref = Database.database().reference();
        refHandle = ref.child("User").observe(DataEventType.value, with: {(snapshot) in
            if let users = snapshot.value as? [NSDictionary] {
                self.userCount = users.count;
            }
        })

    }
    
    @IBAction func signUpRecord() {
        //generate coordinates
        let currLat = Double.random(in:39.938 ..< 39.965)
        let currLong = Double.random(in:-75.2 ..< -75.184)
        if let tel = Int(userField.text!),
            let name = nameField.text {
            self.ref.child("User").child(String(userCount)).setValue(["lat": currLat, "long":  currLong,"tel":tel, "name":name,"supplyNumber":0, "supplyType":"none", "type":"self", "uid":userCount])
        }
    }
}

