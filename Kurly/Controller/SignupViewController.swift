//
//  SignupViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 28/08/2021.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField = TextFieldDesigner.updateTextField(for: emailField)
        usernameField = TextFieldDesigner.updateTextField(for: usernameField)
        passwordField = TextFieldDesigner.updateTextField(for: passwordField)
        signupButton.layer.cornerRadius = 10
        
    }
    


}
