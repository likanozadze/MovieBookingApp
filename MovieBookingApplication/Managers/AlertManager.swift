//
//  AlertManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/19/24.
//


import UIKit

final class AlertManager {
    // MARK: - Shared Instance
    static let shared = AlertManager()
    
    // MARK: - Private Init
    private init() {}
    
    enum AlertType {
        case selectionIncomplete
        case selectSeats
        case paymentSuccessful
        case paymentFailed(message: String)
       
    }
    // MARK: - Methods
    
    func showAlert(from viewController: UIViewController, type: AlertType, completion: (() -> Void)? = nil) {
        let alert: UIAlertController
        
        switch type {
        case .selectionIncomplete:
            alert = createAlert(title: "Selection Incomplete", message: "Please select a date and a time slot.")
        case .selectSeats:
            alert = createAlert(title: "No Seats Selected", message: "Please select at least one seat.")
        case .paymentSuccessful:
            alert = createAlert(title: "Payment Successful", message: "Your payment has been processed successfully.")
        case .paymentFailed(let message):
            alert = createAlert(title: "Payment Failed", message: message)
        }
        
        viewController.present(alert, animated: true)
    }
    
        private func createAlert(title: String, message: String) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            return alert
        }
    }
