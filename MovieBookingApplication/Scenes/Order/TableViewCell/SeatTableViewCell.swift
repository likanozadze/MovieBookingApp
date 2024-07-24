//
//  SeatTableViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import UIKit

class SeatTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let seatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var seatPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [seatLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        configureAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(seatPriceStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func configureAppearance() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    // MARK: - Public Methods
    func configure(with seat: Seat, showTime: ShowTime, ticketPrices: [TicketPrice]) {
        seatLabel.text = "Row \(seat.row), Seat \(seat.seatCode)"
        if let price = ticketPrices.first(where: { $0.priceCategory == getPriceCategory(for: showTime) })?.price {
            priceLabel.text = String(format: "$%.2f", price)
        } else {
            priceLabel.text = "Price: N/A"
        }
    }

    
     func getPriceCategory(for showTime: ShowTime) -> TicketPriceCategory {
        switch showTime {
        case .afternoon1: return .afternoon1
        case .afternoon2: return .afternoon2
        case .evening: return .evening
        case .night1: return .night1
        case .night2: return .night2
        }
    }
}
