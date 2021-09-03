//
//  LoginViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 28/08/2021.
//

import UIKit
import Firebase
import NVActivityIndicatorView


class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField = TextFieldDesigner.updateTextField(for: emailField)
        passwordField = TextFieldDesigner.updateTextField(for: passwordField)
        loginButton.layer.cornerRadius = 10
        containingView.isHidden = true
    }
  
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailField.text , let pass = passwordField.text {
            
            self.containingView.isHidden = false
            self.activityIndicatorView.startAnimating()
            Auth.auth().signIn(withEmail: email, password: pass) { result, error in
                if let error = error {
                    
                    self.containingView.isHidden = true
                    self.activityIndicatorView.startAnimating()
                    ErrorHandler.showError(title: "Error Loging In", errorBody: error.localizedDescription, senderView: self)
                }
                else {

                    self.db.collection("users").document(Auth.auth().currentUser!.email!).getDocument() { document, error in
                        if let error = error {
                            print(error)
                        }
                        else {
                            let result = document!.data()!
                            if result["isBarber"] as! Int == 0 {
                                self.performSegue(withIdentifier: K.customerLoginSegue, sender: self)
                            }else {
                                self.performSegue(withIdentifier: K.barberLoginSegue, sender: self)

                            }
                        }
                    }
                }
            }
        }
    }
    

}
