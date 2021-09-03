//
//  CustomerBarberViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 01/09/2021.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class CustomerBarberViewController: UIViewController,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var makeReservationButton: UIButton!
    
    let db = Firestore.firestore()
    var services = [["type":"Haircut" ,"chosen": false], ["type":"Beard Trim" ,"chosen": false], ["type": "Skin Care" ,"chosen": false], ["type": "Hair Creatine" ,"chosen": false], ["type": "Hair Dryer","chosen": false]]
    var barberEmail:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.barberNibCellName, bundle: nil), forCellReuseIdentifier: K.barbersNameCell)
        tableView.rowHeight = 70.0
        makeReservationButton.layer.cornerRadius = 10
        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(services.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.barbersNameCell) as! BarberCell
        cell.serviceName.text = services[indexPath.row]["type"] as? String
        
        return cell
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        for i in 0...4 {
            let index = IndexPath(row: i, section: 0)
            let cell: BarberCell = self.tableView.cellForRow(at: index) as! BarberCell
            services[i]["chosen"] = cell.serviceSwich.isOn
        }
        var chosenServices: [String] = []
        for s in services {
            if s["chosen"] as! Bool == true {
                chosenServices.append(s["type"] as! String)
            }
            
        }
        let customerEmail = Auth.auth().currentUser?.email
        db.collection("users").document(customerEmail!).getDocument { ds, error in
            if let error = error {
                print(error)
            }
            if let document = ds, document.exists {
                let reservation = Reservation(barberEmail: self.barberEmail, barberName: self.navigationItem.title! , customerEmail: customerEmail!, customerName: document.data()!["name"] as! String, hasExpired: false, services: chosenServices)
                self.addReservation(with: reservation)
            }
            
        }
    }
    
    func addReservation(with reservation: Reservation) {
        do {
            let _ = try self.db.collection("reservations").addDocument(from: reservation)
        }
        catch {
            print(error)
        }

    }
}
