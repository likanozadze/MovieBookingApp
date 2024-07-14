//
//  Time.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/13/24.
//

import Foundation

enum ShowTime: Int, CaseIterable {
    case afternoon1 = 1330
    case afternoon2 = 1630
    case evening = 1900
    case night1 = 2145
    case night2 = 2215
    
    var components: (hour: Int, minute: Int) {
        let hour = self.rawValue / 100
        let minute = self.rawValue % 100
        return (hour, minute)
    }
    
    var formattedTime: String {
        let (hour, minute) = self.components
        return String(format: "%02d:%02d", hour, minute)
    }
}

enum TicketPriceCategory: Double, CaseIterable {
    case afternoon1 = 13.0
    case afternoon2 = 15.0
    case evening = 18.0
    case night1 = 20.0
    case night2 = 25.0
}

struct TimeSlot {
    let date: Date
    let showTime: ShowTime
    var ticketPrices: [TicketPrice]
    
    var startTime: Date {
        let calendar = Calendar.current
        let (hour, minute) = showTime.components
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
    }
    
    var endTime: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: 2, to: startTime)!
    }
}

struct TicketPrice {
    let priceCategory: TicketPriceCategory
    let currency: String
    
    var price: Double {
        return priceCategory.rawValue
    }
}
