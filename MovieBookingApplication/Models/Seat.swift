//
//  Seat.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import Foundation

struct Seat {
  var section: Int
  var row: Int
  var selected: Bool
  var sold: Bool
  var type: String?

  var seatCode: String {
    get { "\(["A", "B", "C", "D", "E", "F", "G", "H", "J"][section])\(row + 1)" }
  }
  
  func isIdentical(_ otherSeat: Seat) -> Bool { seatCode == otherSeat.seatCode }

  init(_ section: Int, _ row: Int, selected: Bool = false, sold: Bool = false, type: String? = nil) {
    self.section = section
    self.row = row
    self.selected = selected
    self.sold = sold
    self.type = type
  }
}
