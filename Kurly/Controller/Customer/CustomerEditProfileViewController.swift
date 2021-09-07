//
//  CustomerEditProfileViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 03/09/2021.
//

import UIKit
import FirebaseFirestore

class CustomerEditProfileViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = K.functions.getLoggedInUser()!.name
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: usernameTextField.frame.height - 1, width: usernameTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        usernameTextField.layer.addSublayer(bottomLine)
        activityIndicator.stopAnimating()
    }
 

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        navigateToBarberView()
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if let name = usernameTextField.text {
            if name.trimmingCharacters(in: .whitespaces).isEmpty {
                ErrorHandler.showError(title: "Please enter a username", errorBody: "You must provide a value for username field", senderView: self)
                return
            }
            activityIndicator.startAnimating()
            db.collection("users").document(K.functions.getLoggedInUser()!.email).setData(["email" : K.functions.getLoggedInUser()!.email, "name" : name ,"isBarber": K.functions.getLoggedInUser()!.isBarber])
            { err in
                if let error = err {
                    print(error)
                }
                else {
                    K.functions.saveUserData(user: User(email: K.functions.getLoggedInUser()!.email, name: name, isBarber: K.functions.getLoggedInUser()!.isBarber))
                    self.navigateToBarberView()
                }
            }
        }
    }
    
    func navigateToBarberView() {
        if let viewController = navigationController?.viewControllers.first(where: {$0 is CustomerViewController}) {
              navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
}
