//
//  ViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 28/08/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 10
        signupButton.layer.cornerRadius = 10
        
    }

}

