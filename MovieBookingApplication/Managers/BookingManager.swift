//
//  BookingManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import Foundation
import UIKit

final class BookingManager {
    
    // MARK: - Shared Instance
    static let shared = BookingManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    var selectedMovie: Movie?
    var selectedDate: Date?
    var selectedTimeSlot: TimeSlot?
    var selectedFood: [Food] = []
    var totalPrice: Double = 0.0
    private let seatManager = SeatManager.shared
    private let foodManager = FoodManager.shared
    private(set) var numberOfTickets: Int = 0
    weak var ticketViewController: TicketViewController?
    weak var tabBarController: TabBarController?
    // MARK: - Methods
    func resetBooking() {
        selectedMovie = nil
        selectedDate = nil
        selectedTimeSlot = nil
        selectedFood.removeAll()
        totalPrice = 0.0
        seatManager.setSeats(for: 0, rowsPerSection: [])
        foodManager.resetQuantities()
        numberOfTickets = 0
        updateBadgeCounts()
    }
    
    func calculateTotalPrice() {
        let ticketPrice = Double(getSelectedSeats().count) * (selectedTimeSlot?.ticketPrices.first?.price ?? 0)
        let foodPrice = foodManager.allFoodItems.reduce(0) { total, food in
            total + food.sizes.reduce(0) { sizeTotal, size in
                sizeTotal + Double(food.quantityPerSize[size.name, default: 0]) * (food.price + size.priceModifier)
            }
        }
        totalPrice = ticketPrice + foodPrice
    }
    
    func getSelectedOrderedFood() -> [OrderedFood] {
        return FoodManager.shared.allFoodItems.flatMap { food in
            food.sizes.compactMap { size in
                let quantity = FoodManager.shared.quantity(for: food, size: size)
                return quantity > 0 ? OrderedFood(food: food, size: size, quantity: quantity) : nil
            }
        }
    }
    
    func setSeats(for sections: Int, rowsPerSection: [Int]) {
        seatManager.setSeats(for: sections, rowsPerSection: rowsPerSection)
    }
    
    func getSeat(by row: Int, seat: Int) -> Seat? {
        return seatManager.getSeat(by: row, seat: seat)
    }
    
    func selectSeat(_ seat: Seat) {
        seatManager.selectSeat(seat)
    }
    
    func deselectSeat(_ seat: Seat) {
        seatManager.deselectSeat(seat)
    }
    
    func updateSeat(_ seat: Seat) {
        seatManager.updateSeat(seat)
    }
    
    func getAllSeats() -> [[Seat]] {
        return seatManager.getAllSeats()
    }
    
    func getSelectedSeats() -> [Seat] {
        return seatManager.getSelectedSeats()
    }
    
    func getBookingSummary() -> (movie: Movie?, seats: [Seat], date: Date?, timeSlot: TimeSlot?) {
        let selectedSeats = getSelectedSeats()
        print("Debug - BookingManager state:")
        print("Selected Movie: \(selectedMovie?.title ?? "nil")")
        print("Selected Date: \(selectedDate?.description ?? "nil")")
        print("Selected Time Slot: \(selectedTimeSlot?.startTime.description ?? "nil")")
        print("Selected Seats: \(selectedSeats.map { $0.seatCode }.joined(separator: ", "))")
        print("Selected Food: \(getSelectedOrderedFood().map { "\($0.quantity)x \($0.food.name)" }.joined(separator: ", "))")
        return (selectedMovie, selectedSeats, selectedDate, selectedTimeSlot)
    }
    
    func completeBooking() {
        numberOfTickets += 1
        updateBadgeCounts()
        updateTicketViewController()
    }
    private func updateTicketViewController() {
            DispatchQueue.main.async { [weak self] in
                self?.ticketViewController?.updateViewState()
            }
        }
    
    func cancelTicket() {
        numberOfTickets = max(0, numberOfTickets - 1)
        updateBadgeCounts()
    }
    
    // MARK: - Update Badge Count

    func updateBadgeCounts() {
           DispatchQueue.main.async { [weak self] in
               guard let self = self else { return }
               if let tabBarController = self.tabBarController {
                   tabBarController.updateBadgeCounts()
               } else {
                   print("Debug - TabBarController reference is nil")
               }
           }
       }
   }
