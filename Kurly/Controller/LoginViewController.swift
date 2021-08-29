//
//  LoginViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 28/08/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField = TextFieldDesigner.updateTextField(for: usernameField)
        passwordField = TextFieldDesigner.updateTextField(for: passwordField)
        loginButton.layer.cornerRadius = 10
    }
    

    

}
