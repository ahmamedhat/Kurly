//
//  SideMenuViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 29/08/2021.
//

import UIKit
import Firebase

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let labels = ["Edit Profile" , "Settings"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.sideMenuCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
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

        if (indexPath.row == 1) {
            performSegue(withIdentifier: K.settingsSegue, sender: self)

        }
        else if indexPath.row == 2 {
            
        }
    }

}
