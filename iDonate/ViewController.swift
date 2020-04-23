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
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var userNameField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!

    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var userCount:Int = 0
    //let locationManager = CCLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userField.layer.cornerRadius = 10.0
        passwordField.layer.cornerRadius = 10.0
        signInButton.layer.cornerRadius = 10.0
        signUpButton.layer.cornerRadius = 10.0
        userNameField.layer.cornerRadius = 10.0
        
        ref = Database.database().reference();
        refHandle = ref.child("User").observe(DataEventType.value, with: {(snapshot) in
            if let users = snapshot.value as? [NSDictionary] {
                self.userCount = users.count;
                print("id count： \(self.userCount)")
            }
        })

    }
    
    @IBAction func signUpRecord() {
        if let tel = Int(userField.text!),
            let password = passwordField.text {
            self.ref.child("User").child(String(userCount)).setValue(["lat": 39.955, "long":  -75.197,"tel":tel, "password":password,"supplyNumber":20, "supplyType":"other", "type":"self", "uid":size ])
            print("new user added!")
        }
    }
    
    @IBAction func signInRecord() {
        if let tel = Int(userField.text!),
            let password = passwordField.text {
           // var currUser: JSONObject = nil
            for currId in 0..<self.userCount {
                if let userEntry = ref.child("User").child(String(currId)) as? NSDictionary,
                let corrPassword = userEntry["password"] as? String,
                    corrPassword == password {
                   print("user is signed in!")
                }
                
                
            }
            
            val Truepassword = ref.child("u").child(String(eggAnnotation.id)).updateChildValues(["collected": eggAnnotation.isCollected])
            self.ref.child("User").child(String(id)).setValue(["lat": 39.955, "long":  -75.197,"tel":tel, "password":password,"supplyNumber":20, "supplyType":"other", "type":"self", "uid":id ])
            print("new user added!")
        }
    }
    
//    ref.child("eggs").child(String(eggAnnotation.id)).updateChildValues(["collected": eggAnnotation.isCollected])
}

