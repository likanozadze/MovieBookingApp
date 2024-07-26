//
//  TicketViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/26/24.
//

import UIKit

class TicketViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    private func setup() {
        setupBackground()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
}
