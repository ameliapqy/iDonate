//
//  DetailViewController.swift
//  iDonate
//
//  Created by Qingyuan Peng on 4/15/20.
//  Copyright © 2020 pqy. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    @IBOutlet var donateBtn: UIButton!
    @IBOutlet var seekBtn: UIButton!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var typeField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var currId:Int = 0
    
    var currType:String = "donor"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.s
        amountField.layer.cornerRadius = 10.0
        typeField.layer.cornerRadius = 10.0
        nextButton.layer.cornerRadius = 10.0
        
        ref = Database.database().reference();
        refHandle = ref.child("User").observe(DataEventType.value, with: {(snapshot) in
            if let users = snapshot.value as? [NSDictionary] {
                self.currId = users.count - 1;
            }
        })
        
    }
    @IBAction func donateCicked() {
        if currType == "seeker" {
            currType = "donor"
            donateBtn.backgroundColor = UIColor.systemBlue
            donateBtn.setTitleColor(UIColor.lightText,for:.normal)
            seekBtn.backgroundColor = UIColor.lightText
            seekBtn.setTitleColor(UIColor.systemBlue,for:.normal)
        }
    }
    
    @IBAction func seekCicked() {
        if currType == "donor" {
            currType = "seeker"
            seekBtn.backgroundColor = UIColor.systemBlue
            seekBtn.setTitleColor(UIColor.lightText,for:.normal)
            donateBtn.backgroundColor = UIColor.lightText
            donateBtn.setTitleColor(UIColor.systemBlue,for:.normal)
        }
    }
    
    @IBAction func recordSupply() {
        if let amount = Int(amountField.text!),
            let supplyType = typeField.text {
            ref.child("User").child(String(self.currId)).updateChildValues(["type": self.currType, "supplyNumber": amount, "supplyType": supplyType])
            print("supply updated!")
        }
    }

}
