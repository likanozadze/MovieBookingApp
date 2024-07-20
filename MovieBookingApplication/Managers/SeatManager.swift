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
    
    // MARK: - Methods
    func setSeats(for sections: Int, rowsPerSection: [Int]) {
        seats = (0..<sections).map { row in
            (1...rowsPerSection[row]).map { seat in
                Seat(row, seat)
            }
        }
    }
    
    func getSeat(by row: Int, seat: Int) -> Seat? {
        guard row < seats.count, seat <= seats[row].count else { return nil }
        return seats[row][seat - 1]
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
    
    func getAllSeats() -> [[Seat]] {
        return seats
    }
}
