//
//  Constants.swift
//  Kurly
//
//  Created by Ahmad Medhat on 29/08/2021.
//

import Foundation

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
    }
    
}
