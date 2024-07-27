//
//  OrderViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import Foundation

final class OrderViewModel {
    
    // MARK: - Properties
    
    private let bookingManager = BookingManager.shared
    
    var selectedOrderedFood: [OrderedFood] {
        return bookingManager.getSelectedOrderedFood()
    }
    
    var selectedMovie: Movie? {
        return bookingManager.selectedMovie
    }
    
    var selectedDate: Date? {
        return bookingManager.selectedDate
    }
    
    var selectedTimeSlot: TimeSlot? {
        return bookingManager.selectedTimeSlot
    }
    
    var selectedSeats: [Seat] {
        return bookingManager.getSelectedSeats()
    }
    
    var totalPrice: Double {
        return bookingManager.totalPrice
    }
    
    var movieTitle: String {
        return selectedMovie?.title ?? "N/A"
    }
    
    var movieGenres: String {
        return selectedMovie?.genres.map { $0.name }.joined(separator: ", ") ?? "N/A"
    }
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Methods
    
    func recalculateTotalPrice() {
        bookingManager.calculateTotalPrice()
    }
}
