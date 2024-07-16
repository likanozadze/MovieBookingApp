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
    private var allSeats: [[Seat]] = []
    private var rowsPerSection: [Int] = []

    // MARK: - Methods
    func setSeats(for sections: Int, rowsPerSection: [Int]) {
        allSeats.removeAll()
        self.rowsPerSection = rowsPerSection
        for section in 0..<sections {
            var sectionSeats: [Seat] = []
            for row in 0..<rowsPerSection[section] {
                let newSeat = Seat(section, row)
                sectionSeats.append(newSeat)
            }
            allSeats.append(sectionSeats)
        }
        print("Seats initialized: \(allSeats.flatMap { $0 }.count) seats for \(sections) sections.")
    }

    func getSeat(by section: Int, row: Int) -> Seat? {
        guard section >= 0 && section < allSeats.count,
              row >= 0 && row < allSeats[section].count else { return nil }
        return allSeats[section][row]
    }

    func getAvailableSeats() -> [Seat] {
        return allSeats.flatMap { $0.filter { !$0.sold } }
    }

    func getSelectedSeats() -> [Seat] {
        return allSeats.flatMap { $0.filter { $0.selected } }
    }

    func selectSeat(_ seat: Seat) {
        guard let index = allSeats[seat.section].firstIndex(where: { $0.isIdentical(seat) }) else { return }
        allSeats[seat.section][index].selected = true
        print("Seat selected: \(seat.seatCode)")
    }

    func deselectSeat(_ seat: Seat) {
        guard let index = allSeats[seat.section].firstIndex(where: { $0.isIdentical(seat) }) else { return }
        allSeats[seat.section][index].selected = false
        print("Seat deselected: \(seat.seatCode)")
    }

    func markSeatSold(_ seat: Seat) {
        guard let index = allSeats[seat.section].firstIndex(where: { $0.isIdentical(seat) }) else { return }
        allSeats[seat.section][index].sold = true
        deselectSeat(seat)
        print("Seat marked as sold: \(seat.seatCode)")
    }
}
