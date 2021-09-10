//
//  BarberCustomerViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 05/09/2021.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class BarberCustomerViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var expectedFinish: UILabel!
    
   

    var reservation : Reservation = Reservation(barberEmail: "", barberName: "", customerEmail: "", customerName: "", hasExpired: false, services: [])
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        
    }
    
    func loadData() {
        db.collection("reservations").whereField("barberEmail", isEqualTo: Auth.auth().currentUser!.email!).whereField("customerEmail", isEqualTo: reservation.customerEmail).getDocuments { qs, error in
            if let error = error {
                print(error)
            }
            else {
                let reservations = qs!.documents.compactMap({ qds -> Reservation? in
                    return try? qds.data(as: Reservation.self)
                })
                
                self.reservation = reservations[0]
                self.getServices(with: self.reservation)
                self.presentLabels(services: self.reservation.services)
            }
        }
    }
    
    func getServices (with reservation: Reservation) {
        let allServicesTime = K.functions.getServicesString(with: reservation)
        let hourString = K.functions.getTimeOfReservation(with: reservation.timeOfReservation!, allServicesTime)
        expectedFinish.text! += " \(hourString)"
        
    }

    func presentLabels(services: [String]) {
        for (i , service) in services.enumerated() {
            let myLabel = UILabel()
            myLabel.translatesAutoresizingMaskIntoConstraints = false
            myLabel.text = service
            myLabel.textAlignment = .left
            myLabel.font.withSize(26)
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
    
    @IBAction func finishPressed(_ sender: UIButton) {
        db.collection("reservations").document(reservation.id!).delete() {err in
            if let error = err {
                print(error)
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
}
