//
//  FakeDataGenerator.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/14/24.
//


import Foundation

class FakeDataGenerator {
    static let fixedShowTimesWithPrices: [(hour: Int, minute: Int, price: Double)] = [
        (13, 30, 13.0),
        (16, 30, 15.0),
        (19, 00, 18.0),
        (21, 45, 20.0),
        (22, 15, 25.0)
    ]
    
    static func generateFakeTimeSlots(forDays days: Int) -> [TimeSlot] {
        var timeSlots = [TimeSlot]()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        
        for dayOffset in 0..<days {
            guard let currentDate = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else {
                continue
            }
            
            for showTimeWithPrice in fixedShowTimesWithPrices {
                guard let startTime = calendar.date(bySettingHour: showTimeWithPrice.hour, minute: showTimeWithPrice.minute, second: 0, of: currentDate),
                      let endTime = calendar.date(byAdding: .hour, value: 2, to: startTime) else {
                    continue
                }
                
                let ticketPrice = TicketPrice(price: showTimeWithPrice.price, currency: "USD")
                
                let timeSlot = TimeSlot(date: currentDate, startTime: startTime, endTime: endTime, ticketPrices: [ticketPrice])
                timeSlots.append(timeSlot)
            }
        }
        
        return timeSlots
    }
}
private func formatPrice(_ price: Double, currency: String) -> String {
    return String(format: "%.0f %@", price, currency)
}
