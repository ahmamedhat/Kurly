//
//  CustomerBarberViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 01/09/2021.


import UIKit
import Firebase
import FirebaseFirestoreSwift

class CustomerBarberViewController: UIViewController,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var isAvailableLabel: UILabel!
    @IBOutlet weak var makeReservationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
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
                let reservation = Reservation(barberEmail: self.barberEmail, barberName: self.navigationItem.title! , customerEmail: customerEmail!, customerName: document.data()!["name"] as! String, hasExpired: false, services: chosenServices,timeOfReservation: self.timePicker.date)
                self.addReservation(with: reservation)
                self.navigationController?.popViewController(animated: true)
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
    
    func loadData() {
        db.collection("reservations").whereField("hasExpired", isEqualTo: false
        ).whereField("barberEmail", isEqualTo: self.barberEmail).getDocuments { qs, error in
            if let error = error {
                print(error)
            }
            
            else {
                let reservations = qs!.documents.compactMap({ qds -> Reservation? in
                    return try? qds.data(as: Reservation.self)
                })
                if reservations.count > 0 {
                    let reservation = self.sortReservations(reservations: reservations)
                    
                    self.getServicesString(with: reservation)
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.isAvailableLabel.text = self.navigationItem.title! + self.isAvailableLabel.text!
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm a"
                    let date = Date()
                    let hourString = formatter.string(from: date)
                    self.setTimePicker(with: hourString)
                }
            }
        }
    }
    
    func getServicesString(with reservation: Reservation) {
        let allServicesTime = K.functions.getServicesString(with: reservation)
        let hourString = K.functions.getTimeOfReservation(with: reservation.timeOfReservation!, allServicesTime)
        isAvailableLabel.text = "\(navigationItem.title!) is available from \(hourString)"
        setTimePicker(with: hourString)
    }

    func setTimePicker(with time:String) {
        
        let timeArray = time.split(separator: ":")
        let timeArray2 = timeArray[1].split(separator: " ")
        var startHour = 0
        if timeArray2[1] == "PM" && Int(timeArray[0])! != 11 && Int(timeArray[0])! != 12{
            startHour = Int(timeArray[0])! + 12
        }
        else {
            startHour = Int(timeArray[0])!
        }
        let startMinute = Int(timeArray2[0])!
        let endHour: Int = 24
        let date1: NSDate = NSDate()
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        let components: NSDateComponents = gregorian.components(([.day, .month, .year]), from: date1 as Date) as NSDateComponents
        components.hour = startHour
        components.minute = startMinute
        components.second = 0
        
        let startDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        
        components.hour = endHour
        components.minute = 0
        components.second = 0
        let endDate: NSDate = gregorian.date(from: components as DateComponents)! as NSDate
        
        timePicker.minimumDate = startDate as Date
        timePicker.maximumDate = endDate as Date
        timePicker.setDate(startDate as Date, animated: true)
        timePicker.reloadInputViews()
        activityIndicator.stopAnimating()
    }
    
    func sortReservations(reservations: [Reservation]) -> Reservation {
        let newReservations = reservations.sorted(by: { lhs, rhs in
            return lhs.timeOfReservation! > rhs.timeOfReservation!
        })
        return newReservations[0]
    }
    
}
