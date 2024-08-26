//
//  Seat.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import Foundation

struct Seat {
    var row: Int
    var seat: Int
    var selected: Bool
    var sold: Bool
    var type: String?
    
    var seatCode: String {
        get { "\(seat)" }
    }
    
    func isIdentical(_ otherSeat: Seat) -> Bool { seatCode == otherSeat.seatCode }
    
    init(_ row: Int, _ seat: Int, selected: Bool = false, sold: Bool = false, type: String? = nil) {
        self.row = row
        self.seat = seat
        self.selected = selected
        self.sold = sold
        self.type = type
    }
}
