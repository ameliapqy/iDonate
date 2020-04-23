//
//  DetailViewController.swift
//  iDonate
//
//  Created by Qingyuan Peng on 4/15/20.
//  Copyright © 2020 pqy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DetailViewController: UIViewController {
    @IBOutlet weak var userTypeField: UISegmentedControl!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var typeField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    var list = ["Donor", "Seeker"]

    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTypeField.layer.cornerRadius = 10.0
        amountField.layer.cornerRadius = 10.0
        typeField.layer.cornerRadius = 10.0
        nextButton.layer.cornerRadius = 10.0
    }

}
