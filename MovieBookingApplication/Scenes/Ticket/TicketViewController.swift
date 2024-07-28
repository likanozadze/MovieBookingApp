//
//  TicketViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/26/24.
//

import UIKit

final class TicketViewController: UIViewController {
    
    // MARK: - Properties
    private let bookingManager = BookingManager.shared
    
    private let ticketView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private let rowLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    private let seatsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    private let barcodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let snacksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        configureTicket()
        setupSubviews()
        setupConstraints()
        
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
        
    }
    private func setupSubviews(){
        view.addSubview(ticketView)
        ticketView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(posterImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(dateLabel)
        contentStackView.addArrangedSubview(timeLabel)
        contentStackView.addArrangedSubview(rowLabel)
        contentStackView.addArrangedSubview(seatsLabel)
        contentStackView.addArrangedSubview(snacksLabel)
        contentStackView.addArrangedSubview(totalPriceLabel)
        contentStackView.addArrangedSubview(barcodeImageView)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ticketView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticketView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ticketView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ticketView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ticketView.heightAnchor.constraint(equalToConstant: 550),
            
            contentStackView.topAnchor.constraint(equalTo: ticketView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: ticketView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: ticketView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: ticketView.bottomAnchor),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 200),
            barcodeImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureTicket() {
        guard let movie = BookingManager.shared.selectedMovie,
              let date = BookingManager.shared.selectedDate,
              let timeSlot = BookingManager.shared.selectedTimeSlot else {
            print("Error: Missing booking details")
            return
        }
        
        ImageLoader.loadImage(from: movie.posterPath) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image ?? UIImage(named: "placeholder")
            }
        }
        
        titleLabel.text = movie.title
        
        dateLabel.text = "Date: \(DateManager.shared.formatDate(date, format: "MMMM dd"))"
        timeLabel.text = "Time: \(timeSlot.showTime.rawValue)"
        
        let selectedSeats = BookingManager.shared.getSelectedSeats()
        let seatNumbers = selectedSeats.map { $0.seatCode }.joined(separator: ", ")
        seatsLabel.text = "Seats: \(seatNumbers)"
        
        
        let orderedFood = BookingManager.shared.getSelectedOrderedFood()
        let snackDetails = orderedFood.map { "\($0.food.name) (\($0.size.name)) x \($0.quantity)" }.joined(separator: ", ")
        snacksLabel.text = "Snacks: \(snackDetails)"
        totalPriceLabel.text = String(format: "$%.2f", BookingManager.shared.totalPrice)
        
        if let firstSeat = selectedSeats.first {
            rowLabel.text = "Row: \(["A", "B", "C", "D", "E", "F", "G", "H", "J"][firstSeat.row])"
        }
        
    }
    
    func updateBadge() {
            let ticketCount = BookingManager.shared.numberOfTickets
            self.tabBarItem.badgeValue = ticketCount > 0 ? "\(ticketCount)" : nil
        }
    
}
