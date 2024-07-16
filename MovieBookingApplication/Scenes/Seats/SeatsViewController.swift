//
//  SeatsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/16/24.
//

//import Foundation
//import UIKit
//
//final class SeatsViewController: UIViewController {
//
//  private let sections = 5
//  private let rowsPerSection = 10
//
//  private var allSeats: [[UIButton]] = []
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    setupSeats()
//  }
//
//  private func setupSeats() {
//    for section in 0..<sections {
//      var rowButtons: [UIButton] = []
//      for row in 0..<rowsPerSection {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "emptySeat"), for: .normal)
//        button.setImage(UIImage(named: "selectedSeat"), for: .selected)
//        button.tag = section * 100 + row  // Unique tag for each seat
//        button.addTarget(self, action: #selector(seatSelected), for: .touchUpInside)
//        rowButtons.append(button)
//        view.addSubview(button)
//      }
//      allSeats.append(rowButtons)
//      // Add constraints or auto layout for positioning buttons
//    }
//  }
//
//  @objc func seatSelected(_ sender: UIButton) {
//    sender.isSelected.toggle()
//    // Handle seat selection logic here
//  }
//}
