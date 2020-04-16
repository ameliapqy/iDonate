//
//  ViewController.swift
//  iDonate
//
//  Created by Qingyuan Peng on 4/12/20.
//  Copyright © 2020 pqy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var userField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userField.layer.cornerRadius = 10.0
        passwordField.layer.cornerRadius = 10.0
        signInButton.layer.cornerRadius = 10.0
        signUpButton.layer.cornerRadius = 10.0
    }


}

