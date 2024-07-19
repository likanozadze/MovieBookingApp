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
    
    // MARK: - Alert Types
    enum AlertType {
        case selectionIncomplete
        
    }
    
    // MARK: - Methods
    func showAlert(from viewController: UIViewController, type: AlertType) {
        let alert: UIAlertController
        
        switch type {
        case .selectionIncomplete:
            alert = createAlert(title: "Selection Incomplete", message: "Please select both a date and a time slot.")
      
        }
        viewController.present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    private func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
