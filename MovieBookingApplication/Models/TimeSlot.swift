//
//  Time.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/13/24.
//
//
import Foundation

struct MockTimeSlot: Decodable, Equatable {
    let time: String
    let price: Double
    
    static func == (lhs: MockTimeSlot, rhs: MockTimeSlot) -> Bool {
        return lhs.time == rhs.time && lhs.price == rhs.price
    }
}
