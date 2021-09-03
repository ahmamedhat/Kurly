//
//  Reservation.swift
//  Kurly
//
//  Created by Ahmad Medhat on 02/09/2021.
//

import Foundation
import FirebaseFirestoreSwift


struct Reservation: Codable , Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var barberEmail: String
    var barberName: String
    var customerEmail: String
    var customerName: String
    var hasExpired: Bool
    var services: [String]
    @ServerTimestamp var timeOfReservation: Date?
}
