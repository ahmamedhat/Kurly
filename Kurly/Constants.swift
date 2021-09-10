//
//  Constants.swift
//  Kurly
//
//  Created by Ahmad Medhat on 29/08/2021.
//

import Foundation
import Firebase

struct K {
    
//    Barber
    
    static let barberSignUpSegue = "signupToBarber"
    static let barberLoginSegue = "loginToBarber"
    static let barberCell = "barberCell"
    static let sideMenuCellIdentifier = "cell"

    static let customerCellNibName = "CustomerCell"
    static let customerCellIdentifier = "customerCell"
    
    static let collectionName = "customers"
    static let settingsSegue = "sideMenuToSettings"
    static let settingsCell = "settingsCell"
    
    static let barberSideMenuToEditProfile = "barberSideMenuToEditProfile"
    
    static let barberToCustomerReservation = "barberToCustomerReservation"
    
//    Customer
    
    static let customerSignupSegue = "signupToCustomer"
    static let customerLoginSegue = "loginToCustomer"
    static let customerToBarbers = "customerToBarbers"
    
    static let barbersNameCell = "barbersNameCell"
    static let barberNibCellName = "BarberCell"
    
    static let customerSideMenuCellIdentifier = "customerSideMenu"
    static let customerSideMenuToReservations = "customerSideMenuToReservations"
    static let customerSideMenuToEditProfile = "customerSideMenuToEditProfile"
    
//    Most Used Functions
    
    struct functions {
        static func getLoggedInUser() -> User? {
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
        
        static func saveUserData(user: User) {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(user)
                UserDefaults.standard.set(data, forKey: "User")
                
            } catch {
                print("Unable to Encode Note (\(error))")
            }
        }
        
        
        static func logOut(view: UIViewController , navigationController: UINavigationController) {
            do {
                try Auth.auth().signOut()
                navigationController.popToRootViewController(animated: true)
            }
            catch {
                ErrorHandler.showError(title: "Error Logging Out", errorBody: error.localizedDescription, senderView: view)
            }
        }
        
        static func getServicesString(with reservation: Reservation) -> Int {
            var allServicesTime = 0
            let services = reservation.services
            for service in services {
                switch service {
                case "Haircut":
                    allServicesTime += 30
                case "Beard Trim":
                    allServicesTime += 10
                case "Skin Care":
                    allServicesTime += 15
                case "Hair Creatine":
                    allServicesTime += 25
                case "Hair Dryer":
                    allServicesTime += 10
                default:
                    return allServicesTime
                }
                
            }
            return allServicesTime
        }
    
        
        static func getTimeOfReservation(with timeOfReservation: Date ,_ time: Int) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let calender = Calendar.current
            let expectedFinishTime = calender.date(byAdding: DateComponents(minute: time), to: timeOfReservation)
            let hourString = formatter.string(from: expectedFinishTime!)
            return hourString
        }
    }
    
}
