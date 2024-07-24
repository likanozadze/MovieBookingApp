//
//  BookingManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import Foundation

final class BookingManager {
    static let shared = BookingManager()
    
    private init() {}
    
    var selectedMovie: Movie?
    var selectedDate: Date?
    var selectedTimeSlot: TimeSlot?
    var selectedSeats: [Seat] = []
    var selectedFood: [Food] = []
    var totalPrice: Double = 0.0
    
    func resetBooking() {
        selectedMovie = nil
        selectedDate = nil
        selectedTimeSlot = nil
        selectedSeats.removeAll()
        selectedFood.removeAll()
        totalPrice = 0.0
    }
    
    func calculateTotalPrice() {
        let ticketPrice = Double(selectedSeats.count) * (selectedTimeSlot?.ticketPrices.first?.price ?? 0)
        let foodPrice = selectedFood.reduce(0) { $0 + $1.price }
        totalPrice = ticketPrice + foodPrice
    }
}
