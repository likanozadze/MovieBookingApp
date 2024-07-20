//
//  SeatManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/16/24.
//

import Foundation

final class SeatManager {
    // MARK: - Shared Instance
    static let shared = SeatManager()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Properties
    private var seats: [[Seat]] = []
    private var rowsPerSection: [Int] = []
    
    // MARK: - Methods
    
    
    func setSeats(for sections: Int, rowsPerSection: [Int]) {
        seats = (0..<sections).map { section in
            (0..<rowsPerSection[section]).map { row in
                Seat(section, row)
            }
        }
    }
    
    func getSeat(by section: Int, row: Int) -> Seat? {
        guard section < seats.count, row < seats[section].count else { return nil }
        return seats[section][row]
    }
    
    func selectSeat(_ seat: Seat) {
        if let index = seats[seat.row].firstIndex(where: { $0.seat == seat.seat }) {
            seats[seat.row][index].selected = true
        }
    }
    
    func deselectSeat(_ seat: Seat) {
        if let index = seats[seat.row].firstIndex(where: { $0.seat == seat.seat }) {
            seats[seat.row][index].selected = false
        }
    }
    func updateSeat(_ seat: Seat) {
        if let index = seats[seat.row].firstIndex(where: { $0.seat == seat.seat }) {
            seats[seat.row][index] = seat
        }
    }
}
