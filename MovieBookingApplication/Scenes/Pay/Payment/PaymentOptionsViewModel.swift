//
//  PaymentOptionsViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.


import Foundation

protocol PaymentOptionsViewModelDelegate: AnyObject {
    func didUpdateCardOptions()
    func didProcessPayment(success: Bool, message: String)
}

final class PaymentOptionsViewModel {
    private(set) var savedCards: [Card] = []
    private(set) var selectedCardIndex: Int?
    
    weak var delegate: PaymentOptionsViewModelDelegate?
    
    func loadSavedCards() {
        savedCards = PaymentManager.shared.getSavedCards()
        selectedCardIndex = savedCards.isEmpty ? nil : 0
        delegate?.didUpdateCardOptions()
    }
    
    func selectCard(at index: Int) {
        guard index < savedCards.count else { return }
        selectedCardIndex = index
    }
    
    func getSelectedCard() -> Card? {
        guard let selectedCardIndex = selectedCardIndex else { return nil }
        return savedCards[selectedCardIndex]
    }

    func processPayment() {
        guard let selectedCard = getSelectedCard() else {
            delegate?.didProcessPayment(success: false, message: "Please select a payment method")
            return
        }
        
        let amount = BookingManager.shared.totalPrice
        PaymentManager.shared.processPayment(amount: amount, card: selectedCard) { [weak self] success, message in
            if success {
                self?.delegate?.didProcessPayment(success: true, message: "Payment successful")
            } else {
                self?.delegate?.didProcessPayment(success: false, message: message ?? "Payment failed")
            }
        }
    }
}
