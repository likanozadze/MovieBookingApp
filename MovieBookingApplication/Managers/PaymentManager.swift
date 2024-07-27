//
//  PaymentManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import Foundation

final class PaymentManager {
    
    // MARK: - Shared Instance
    static let shared = PaymentManager()
    
    // MARK: - Private Init
    private init() {
        balance = UserDefaults.standard.double(forKey: "userBalance")
        if balance == 0 {
            balance = initialBalance
            UserDefaults.standard.set(balance, forKey: "userBalance")
        }
    }
    // MARK: - Properties
    private var savedCards: [Card] = []
    private let initialBalance: Double = 100.0 
    private(set) var balance: Double {
        didSet {
            UserDefaults.standard.set(balance, forKey: "userBalance")
        }
    }
    
    // MARK: - Methods
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
            let isSuccessful = amount <= 100.0
            let message = isSuccessful ? "Payment successful" : "Payment failed: Amount exceeds $100 limit"
            
            if isSuccessful {
                self.balance -= amount
            }
            
            DispatchQueue.main.async {
                completion(isSuccessful, message)
            }
        }
    }
    func addFunds(_ amount: Double) {
        balance += amount
    }
    
    func getBalance() -> Double {
        return balance
    }
}
