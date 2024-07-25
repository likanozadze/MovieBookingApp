//
//  PaymentManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import Foundation

class PaymentManager {
    static let shared = PaymentManager()
    
    private init() {}
    
    private var savedCards: [Card] = []
    
    func addCard(_ card: Card) {
        savedCards.append(card)
    }
    
    func getSavedCards() -> [Card] {
        return savedCards
    }
    
    func removeCard(_ card: Card) {
        savedCards.removeAll { $0.id == card.id }
    }
    
    func processPayment(amount: Double, card: Card, completion: @escaping (Bool, String?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let isSuccessful = Bool.random()
            let message = isSuccessful ? "Payment successful" : "Payment failed"
            DispatchQueue.main.async {
                completion(isSuccessful, message)
            }
        }
    }
}
