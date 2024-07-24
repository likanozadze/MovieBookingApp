//
//  File.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import UIKit

class SnackTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    private let nameLabel: UILabel = {
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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
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
            contentView.addSubview(stackView)
            stackView.addArrangedSubview(nameLabel)
            stackView.addArrangedSubview(priceLabel)
        }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func configureAppearance() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    

    func configure(with snack: Food, size: FoodSize, price: Double, quantity: Int) {
        nameLabel.text = "\(snack.name) (\(size.name))"
        priceLabel.text = String(format: "$%.2f X %d", price, quantity)
    }
}

