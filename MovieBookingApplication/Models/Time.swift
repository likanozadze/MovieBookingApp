//
//  Time.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/13/24.
//

import Foundation


struct TimeSlot {
    let date: Date
    let startTime: Date
    let endTime: Date
    let ticketPrices: [TicketPrice]
    let movie: Movie
}

enum SeatType: String {
    case regular
    case balcony
    case vip
}

struct TicketPrice {
    let seatType: SeatType
    let price: Double
}
