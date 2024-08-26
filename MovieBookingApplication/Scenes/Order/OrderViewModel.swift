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
    
    var selectedMovie: MockMovie? {
        return bookingManager.selectedMockMovie
    }
    
    var selectedDate: Date? {
        return bookingManager.selectedDate
    }
    
    var selectedTimeSlot: MockTimeSlot? {
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
    
    func getFoodImageName(for orderedFood: OrderedFood) -> String {
           return orderedFood.food.imageName
       }
 
    var selectedShowtime: MovieShowtime? { 
      guard let movie = selectedMovie,
            let _ = selectedDate,
            let timeSlot = selectedTimeSlot else {
        return nil
      }
      
      return MovieShowtime(time: timeSlot.time, movie: movie, price: timeSlot.price, hall: 1, ageRating: 0)
    }

    // MARK: - Methods
    
    func recalculateTotalPrice() {
        bookingManager.calculateTotalPrice()
    }
}
