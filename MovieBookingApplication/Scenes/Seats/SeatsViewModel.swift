//
//  SeatsViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/21/24.
//

import UIKit

final class SeatsViewModel {
    // MARK: - Properties
    
    let dates: [Date]
    let timeSlots: [MockTimeSlot]
    let movie: MockMovie
    private(set) var selectedDateIndex: Int?
    private(set) var selectedTimeSlotIndex: Int?
    let seatManager = SeatManager.shared
    let rowsPerSection = [8, 8, 8, 8]
    
    // MARK: - Init
    init(selectedDate: Date, selectedTimeSlot: MockTimeSlot, dates: [Date], timeSlots: [MockTimeSlot], movie: MockMovie) {
        self.dates = dates
        self.timeSlots = timeSlots
        self.movie = movie
        self.selectedDateIndex = dates.firstIndex(of: selectedDate)
    self.selectedTimeSlotIndex = timeSlots.firstIndex(where: { $0.time == selectedTimeSlot.time })
    }
    
    // MARK: - Methods
    func initializeSeats() {
        let numberOfSections = rowsPerSection.count
        seatManager.setSeats(for: numberOfSections, rowsPerSection: rowsPerSection)
    }
    
    func selectDate(at index: Int) {
        selectedDateIndex = index
    }
    
    func selectTimeSlot(at index: Int) {
        selectedTimeSlotIndex = index
    }
    
    func getSelectedSeats() -> [Seat] {
        return seatManager.getSelectedSeats()
    }
    
    func getSeat(for indexPath: IndexPath) -> Seat? {
        return seatManager.getSeat(by: indexPath.section, seat: indexPath.row + 1)
    }
    
    func canProceedToFoodSelection() -> Bool {
        return selectedTimeSlotIndex != nil && !getSelectedSeats().isEmpty
    }
    
}
