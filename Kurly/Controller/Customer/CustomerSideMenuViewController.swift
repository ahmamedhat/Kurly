//
//  CustomerSideMenuViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 02/09/2021.
//

import UIKit

class CustomerSideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userIcon: UIBarButtonItem!
    
    let labels = ["Edit Profile" , "Reservations" , "Settings"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.customerSideMenuCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = getLoggedInUser()!.name

    }

  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let label = labels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.sideMenuCellIdentifier)
        cell?.textLabel?.text = label
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: K.customerSideMenuToEditProfile, sender: self)
        }
        else if (indexPath.row == 1) {
            performSegue(withIdentifier: K.customerSideMenuToReservations, sender: self)

        }
        
    }
    
    
    func getLoggedInUser() -> User? {
        if let data = UserDefaults.standard.data(forKey: "User") {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return nil
    }

    
}
