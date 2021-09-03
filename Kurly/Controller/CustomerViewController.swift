//
//  CustomerViewController.swift
//  Kurly
//
//  Created by Ahmad Medhat on 31/08/2021.
//

import UIKit
import Firebase
import ViewAnimator

class CustomerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    

    @IBOutlet weak var viewTable: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    private let searchController = UISearchController(searchResultsController: nil)

    let db = Firestore.firestore()

    var matches : [String] = []
    var barbers : [String] = []
    var barbersEmail : [String] = []
    var barbersEmailMatches: [String] = []
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        viewTable.rowHeight = 127.0
        viewTable.dataSource = self
        viewTable.delegate = self
        viewTable.isHidden = true
        viewTable.register(UINib(nibName: K.customerCellNibName, bundle: nil), forCellReuseIdentifier: K.customerCellIdentifier)

        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Barbers"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        self.loadData()

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let animation = AnimationType.from(direction: .bottom, offset: 300)
        UIView.animate(views: viewTable.visibleCells, animations: [animation])
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationItem.searchController?.searchBar.isHidden = false
        viewTable.isHidden = false

    }

    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.searchController?.searchBar.isHidden = true
        viewTable.isHidden = true

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? matches.count : barbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.customerCellIdentifier) as! CustomerCell
        
        cell.nameLabel.isHidden = true
        cell.timeLabel.isHidden = true
        cell.serviceLabel.text = searching ? matches[indexPath.row] : barbers[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.customerToBarbers, sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func loadData() {
        
        db.collection("users").whereField("isBarber", isEqualTo: true).getDocuments(completion: { qr, error in
            if let error = error {
                print(error)
            }
            else {
                
                for document in qr!.documents {
                    let barber = document["name"] as! String
                    let barberEmail = document["email"] as! String
                    self.barbers.append(barber)
                    self.barbersEmail.append(barberEmail)
                }
            }
            DispatchQueue.main.async {
                self.viewTable.reloadData()
            }
        })
    }
    
   
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            searchBarCancelButtonClicked(searchController.searchBar)
        }
        if let searchText = searchController.searchBar.text,
           !searchText.isEmpty {
            matches.removeAll()
            barbersEmailMatches.removeAll()
            
            for index in 0 ..< barbers.count {
                if barbers[index].lowercased().contains(
                    searchText.lowercased()) {
                    matches.append(barbers[index])
                    barbersEmailMatches.append(barbersEmail[index])
                }
            }
            DispatchQueue.main.async {
                self.viewTable.reloadData()
            }
            searching = true
        } else {
            searching = false
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        viewTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.customerToBarbers {
            let destinationVc = segue.destination as! CustomerBarberViewController
            if let index = viewTable.indexPathForSelectedRow {
                destinationVc.title = searching ? matches[index.row] : barbers[index.row]
                destinationVc.barberEmail = searching ? barbersEmailMatches[index.row] : barbersEmail[index.row]
            }
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
