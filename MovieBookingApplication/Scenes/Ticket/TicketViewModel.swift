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
    
    var hasTickets: Bool {
        return bookingManager.numberOfTickets > 0
    }
    
    var movieTitle: String? {
        return bookingManager.selectedMovie?.title
    }
    
    var posterPath: String? {
        return bookingManager.selectedMovie?.posterPath
    }
    
    var formattedDate: String? {
        guard let date = bookingManager.selectedDate else { return nil }
        return "Date: \(DateManager.shared.formatDate(date, format: "MMMM dd"))"
    }
    
    var formattedTime: String? {
        guard let timeSlot = bookingManager.selectedTimeSlot else { return nil }
        if let formattedTime = DateManager.shared.formatTime(String(timeSlot.showTime.rawValue)) {
            return "Time: \(formattedTime)"
        } else {
            return "Time: \(timeSlot.showTime.rawValue)"
        }
    }
    
    var seatInfo: String? {
        let selectedSeats = bookingManager.getSelectedSeats()
        let seatNumbers = selectedSeats.map { $0.seatCode }.joined(separator: ", ")
        return "Seats: \(seatNumbers)"
    }
    
    var rowInfo: String? {
        let selectedSeats = bookingManager.getSelectedSeats()
        if let firstSeat = selectedSeats.first {
            return "Row: \(["A", "B", "C", "D", "E", "F", "G", "H", "J"][firstSeat.row])"
        }
        return nil
    }
    
    var snackInfo: String? {
        let orderedFood = bookingManager.getSelectedOrderedFood()
        let snackDetails = orderedFood.map { "\($0.food.name) (\($0.size.name)) x \($0.quantity)" }.joined(separator: ", ")
        return "Snacks: \(snackDetails)"
    }
    
    var totalPrice: String {
        return String(format: "$%.2f", bookingManager.totalPrice)
    }
    
    var ticketCount: Int {
        return bookingManager.numberOfTickets
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let posterPath = posterPath else {
            completion(UIImage(named: "placeholder"))
            return
        }
        
        ImageLoader.loadImage(from: posterPath) { image in
            completion(image ?? UIImage(named: "placeholder"))
        }
    }
}
