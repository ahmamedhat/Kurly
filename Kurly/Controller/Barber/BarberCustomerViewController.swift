//
//  BarberCustomerViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 05/09/2021.
//

import UIKit

class BarberCustomerViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
   

    var reservation : Reservation = Reservation(barberEmail: "", barberName: "", customerEmail: "", customerName: "", hasExpired: false, services: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for i in 0...5 {
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myLabel.text = "Upper label this a test label"
            myLabel.textAlignment = .left
            
            stackView.addSubview(myLabel)

            
            let margineGuide = view.layoutMarginsGuide
            NSLayoutConstraint.activate([
            myLabel.topAnchor.constraint(equalTo: margineGuide.topAnchor, constant: CGFloat(60*i + 30)),
            myLabel.leadingAnchor.constraint(equalTo: margineGuide.leadingAnchor),
            myLabel.heightAnchor.constraint(equalToConstant: 40),
            myLabel.trailingAnchor.constraint(equalTo: margineGuide.trailingAnchor)
            ])

        }
        
    }
    
    

}
