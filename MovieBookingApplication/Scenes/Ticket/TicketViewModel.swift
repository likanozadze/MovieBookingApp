//
//  TicketViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/28/24.
//

import Foundation
import UIKit

class TicketViewModel {
    
    private let bookingManager = BookingManager.shared
    private(set) var tickets: [Ticket] = []
    
    var hasTickets: Bool {
        return !tickets.isEmpty
    }
    
    func loadTickets() {
        tickets = CoreDataManager.shared.fetchTickets()
        print("Debug - Fetched \(tickets.count) tickets from Core Data")
    }
    
    var currentTicket: Ticket? {
        return tickets.last
    }
    
    var movieTitle: String? {
        return currentTicket?.movieTitle
    }
    
    var formattedDate: String? {
        guard let date = currentTicket?.date else { return nil }
        return "Date: \(DateManager.shared.formatDate(date, format: "MMMM dd"))"
    }
    
    var formattedTime: String? {
        guard let time = currentTicket?.timeSlot else { return nil }
        return "Time: \(time)"
    }
    
    var seatInfo: String? {
        return "Seats: \(currentTicket?.seats ?? "")"
    }
    
    var rowInfo: String? {
        guard let seats = currentTicket?.seats?.split(separator: ",").first else { return nil }
        return "Row: \(seats.prefix(1))"
    }
    
    var snackInfo: String? {
        return "Snacks: \(currentTicket?.snacks ?? "")"
    }
    
    var totalPrice: String {
        return String(format: "$%.2f", currentTicket?.totalPrice ?? 0)
    }
    
    var ticketCount: Int {
        return tickets.count
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let posterPath = currentTicket?.posterPath else {
            completion(UIImage(named: "placeholder"))
            return
        }
        
        NetworkManager.shared.downloadImage(from: posterPath) { image in
            DispatchQueue.main.async {
                completion(image ?? UIImage(named: "placeholder"))
            }
        }
    }
}
