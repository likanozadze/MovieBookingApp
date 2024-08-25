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
        layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 12
        
        contentView.layer.cornerRadius = layer.cornerRadius
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    // MARK: - Public Methods   
    func configure(with seat: Seat, price: Double) {
        seatLabel.text = "Row \(seat.row), Seat \(seat.seatCode)"
        priceLabel.text = String(format: "$%.2f", price)
    }
    
}
