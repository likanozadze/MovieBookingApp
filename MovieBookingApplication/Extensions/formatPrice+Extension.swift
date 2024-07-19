//
//  formatPrice+Extension.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/19/24.
//

import Foundation

extension Double {
    func formatPrice(currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if let formattedPrice = formatter.string(from: NSNumber(value: self)) {
            return formattedPrice
        } else {
            return String(format: "%.2f %@", self, currency)
        }
    }
}
