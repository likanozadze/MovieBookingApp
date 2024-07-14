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
    var ticketPrices: [TicketPrice]
}

struct TicketPrice {
    let price: Double
    let currency: String
}
