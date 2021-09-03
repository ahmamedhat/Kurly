//
//  SignupViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 28/08/2021.
//

import UIKit
import Firebase
import NVActivityIndicatorView


class SignupViewController: UIViewController {

    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loadingIndicator: NVActivityIndicatorView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var isBarberSwitch: UISwitch!
    @IBOutlet weak var signupButton: UIButton!
    
    private let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField = TextFieldDesigner.updateTextField(for: usernameField)
        emailField = TextFieldDesigner.updateTextField(for: emailField)
        passwordField = TextFieldDesigner.updateTextField(for: passwordField)
        signupButton.layer.cornerRadius = 10
        containerView.isHidden = true

    }
    
    
    @IBAction func signupPressed(_ sender: UIButton) {
        if let name = usernameField.text , let email = emailField.text , let pass = passwordField.text {
            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                ErrorHandler.showError(title: "Please enter a username", errorBody: "Cannot create an acount with this field empty", senderView: self)
                return
            }
            containerView.isHidden = false
            loadingIndicator.startAnimating()
            Auth.auth().createUser(withEmail: email, password: pass) { result, error in
                if let error = error {
                    self.containerView.isHidden = true
                    self.loadingIndicator.stopAnimating()
                    ErrorHandler.showError(title: "Error Signing Up", errorBody: error.localizedDescription, senderView: self)
                }
                else {
                    self.db.collection("users").document(Auth.auth().currentUser!.email!).setData(["isBarber": self.isBarberSwitch.isOn , "email": Auth.auth().currentUser!.email! , "name": name])
                                                                                                    
                    self.isBarberSwitch.isOn ? self.performSegue(withIdentifier: K.barberSignUpSegue , sender: self) : self.performSegue(withIdentifier: K.customerSignupSegue , sender: self)
                }
            }
        }
    }
    
}
