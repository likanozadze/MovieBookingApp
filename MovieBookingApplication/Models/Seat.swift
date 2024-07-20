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
    get { "\(["A", "B", "C", "D", "E", "F", "G", "H", "J"][row])\(seat + 1)" }
  }
  
  func isIdentical(_ otherSeat: Seat) -> Bool { seatCode == otherSeat.seatCode }

  init(_ section: Int, _ row: Int, selected: Bool = false, sold: Bool = false, type: String? = nil) {
    self.row = section
    self.seat = row
    self.selected = selected
    self.sold = sold
    self.type = type
  }
}
