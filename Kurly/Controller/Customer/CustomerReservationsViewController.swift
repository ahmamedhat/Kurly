//
//  CustomerReservationsViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 02/09/2021.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import ViewAnimator

class CustomerReservationsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    
    var reservations: [Reservation] = []
    var servicesInString: [String] = []
    var timesInString: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 127.0
        tableView.register(UINib(nibName: K.customerCellNibName, bundle: nil), forCellReuseIdentifier: K.customerCellIdentifier)
        tableView.isHidden = true
        
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        let animation = AnimationType.from(direction: .bottom, offset: 300)
        UIView.animate(views: tableView.visibleCells, animations: [animation])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.customerCellIdentifier) as! CustomerCell
        cell.nameLabel.text = reservations[indexPath.row].barberName
        cell.serviceLabel.text = servicesInString[indexPath.row]
        cell.timeLabel.text = timesInString[indexPath.row]
        return cell
    }
    
    func loadData() {
        db.collection("reservations").whereField("customerEmail", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { qs, error in
            if let error = error {
                print(error)
            }
            
            else {
                let reservations = qs!.documents.compactMap({ qds -> Reservation? in
                    return try? qds.data(as: Reservation.self)
                })
                for reservation in reservations {
                    self.reservations.append(reservation)
                }
                self.getServicesString()
                self.getTimeOfReservation()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func getServicesString() {
        var servicesArray: [[String]] = []
        for reservation in reservations {
            servicesArray.append(reservation.services)
        }
        for (services) in servicesArray {
            var servicesString = ""
            for (index2 , service) in services.enumerated() {
                if (index2 == services.count - 1) {
                    servicesString += "\(service)"
                }
                else {
                    servicesString += "\(service), "
                }
                
            }
            servicesInString.append(servicesString)
        }
        
    }
    
    func getTimeOfReservation() {
        var times: [Date] = []
        for reservation in reservations {
            times.append(reservation.timeOfReservation!)
        }
        
        for time in times {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let hourString = formatter.string(from: time)
            timesInString.append(hourString)
        }
        
    }

}
