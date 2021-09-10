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
        
        
        tableView.contentInsetAdjustmentBehavior = .never
        navigationItem.largeTitleDisplayMode = .automatic

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
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
        performSegue(withIdentifier: K.barberToCustomerReservation, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.barberToCustomerReservation {
            let destinationVC = segue.destination as! BarberCustomerViewController
            destinationVC.navigationItem.title = reservations[tableView.indexPathForSelectedRow!.row].customerName
            destinationVC.reservation = reservations[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func loadData() {
        print("passed")
        reservations.removeAll()
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
                self.filterReservations()
                self.sortReservations()
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
    
    func filterReservations() {
        var date = Date()
        date.addTimeInterval(TimeInterval(-1 * 60.0 * 60.0))
        let newReservations = reservations.filter { reservation in
            return reservation.timeOfReservation! > date
        }
        let filteredReservations = reservations.filter { reservation in
            return reservation.timeOfReservation! < date
        }
        for reservation in filteredReservations {
            db.collection("reservations").document(reservation.id!).delete(){err in
                if let error = err {
                    print(error)
                }
                else {
                    
                }
                
            }
        }
        self.reservations = newReservations
    }
    
    func sortReservations() {
        let sortedReservations = reservations.sorted(by: { lhs, rhs in
            return lhs.timeOfReservation! < rhs.timeOfReservation!
        })
        reservations = sortedReservations
    }
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        K.functions.logOut(view: self as UIViewController, navigationController: navigationController!)
    }
}
