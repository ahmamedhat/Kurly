//
//  BarberViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 29/08/2021.
//

import UIKit
import ViewAnimator
import Firebase
import FirebaseFirestoreSwift

class BarberViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    var reservations: [Reservation] = []
    var servicesInString: [String] = []
    var timesInString: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.rowHeight = 127.0
        tableView.delegate = self
        tableView.isHidden = true
        tableView.register(UINib(nibName: K.customerCellNibName, bundle: nil) , forCellReuseIdentifier: K.customerCellIdentifier)
        loadData()
        
        tableView.contentInsetAdjustmentBehavior = .never
        navigationItem.largeTitleDisplayMode = .automatic

    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
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
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: K.customerCellIdentifier) as! CustomerCell
        cell.nameLabel.text = reservations[indexPath.row].customerName
        cell.serviceLabel.text = servicesInString[indexPath.row]
        cell.timeLabel.text = timesInString[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadData() {
        db.collection("reservations").whereField("barberEmail", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { qs, error in
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
//        var calendar = Calendar.current
//        if let timeZone = TimeZone(secondsFromGMT: 7200) {
//           calendar.timeZone = timeZone
//        }
        
        for time in times {
//            let hour = calendar.component(.hour, from: time)
//            let minute = calendar.component(.minute, from: time)
            
//            timesInString.append("\(hour):\(minute)")
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let hourString = formatter.string(from: time)
            timesInString.append(hourString)
        }
        
    }
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            ErrorHandler.showError(title: "Error Logging Out", errorBody: error.localizedDescription, senderView: self)
        }
    }
    
}
