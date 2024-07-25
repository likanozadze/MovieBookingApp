//
//  Card.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import Foundation

struct Card: Codable {
    let id: String
    let cardholderName: String
    let cardNumber: String
    let expirationDate: String
    let cvc: String
    let brand: CardBrand
    
    enum CardBrand: String, Codable {
        case visa
        case mastercard
        case amex
        case discover
        case other
    }
}
