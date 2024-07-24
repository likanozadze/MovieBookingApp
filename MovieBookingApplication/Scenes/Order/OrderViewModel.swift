//
//  OrderViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import Foundation

final class OrderViewModel {
    
    let bookingManager = BookingManager.shared
    var selectedOrderedFood: [OrderedFood] { bookingManager.getSelectedOrderedFood() }
    var movie: Movie? { bookingManager.selectedMovie }
    var selectedDate: Date? { bookingManager.selectedDate }
    var selectedTimeSlot: TimeSlot? { bookingManager.selectedTimeSlot }
    var selectedSeats: [Seat] { bookingManager.getSelectedSeats() }
    var totalPrice: Double { bookingManager.totalPrice }
    func recalculateTotalPrice() {
          bookingManager.calculateTotalPrice()
      }
    
    
}
