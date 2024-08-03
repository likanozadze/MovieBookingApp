//
//  TicketCollectionViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/3/24.
//

import Foundation
import UIKit

class TicketCollectionViewCell: UICollectionViewCell {
    
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
    
    private lazy var dateTimeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var snackStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [snacksLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(ticketView)
        ticketView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(posterImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(dateTimeStackView)
        contentStackView.addArrangedSubview(rowLabel)
        contentStackView.addArrangedSubview(seatsLabel)
        contentStackView.addArrangedSubview(snackStackView)
        contentStackView.addArrangedSubview(totalPriceLabel)
        contentStackView.addArrangedSubview(barcodeImageView)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ticketView.topAnchor.constraint(equalTo: contentView.topAnchor),
            ticketView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ticketView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ticketView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: ticketView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: ticketView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: ticketView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: ticketView.bottomAnchor),
            
            posterImageView.heightAnchor.constraint(equalToConstant: 180),
            barcodeImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    func configure(with ticket: Ticket) {
        titleLabel.text = ticket.movieTitle
        dateLabel.text = "Date: \(DateManager.shared.formatDate(ticket.date ?? Date(), format: "MMMM dd"))"
        timeLabel.text = "Time: \(ticket.timeSlot ?? "")"
        seatsLabel.text = "Seats: \(ticket.seats ?? "")"
        
        if let seats = ticket.seats?.split(separator: ",").first {
            rowLabel.text = "Row: \(seats.prefix(1))"
        }
        
        snacksLabel.text = "Snacks: \(ticket.snacks ?? "")"
        totalPriceLabel.text = String(format: "$%.2f", ticket.totalPrice)
        posterImageView.image = UIImage(named: "coca")

        if let posterPath = ticket.posterPath {
            print("Debug - Loading image for ticket: \(ticket.movieTitle ?? "Unknown"), Poster Path: \(posterPath)")
            NetworkManager.shared.downloadImage(from: posterPath) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.posterImageView.image = image
                        print("Debug - Image loaded successfully for: \(ticket.movieTitle ?? "Unknown")")
                    } else {
                        print("Debug - Failed to load image for: \(ticket.movieTitle ?? "Unknown")")
                    }
                }
            }
        } else {
            print("Debug - No poster path for ticket: \(ticket.movieTitle ?? "Unknown")")
        }
    
        barcodeImageView.image = UIImage(named: "barcode")
    }
}

