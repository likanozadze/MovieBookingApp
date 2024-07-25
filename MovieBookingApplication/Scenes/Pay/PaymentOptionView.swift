//
//  PaymentOptionView.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import UIKit

class PaymentOptionView: UIView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemBlue
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var isSelected: Bool = false {
        didSet {
            checkmarkImageView.isHidden = !isSelected
        }
    }
    
    init(icon: UIImage?, title: String, subtitle: String?) {
        super.init(frame: .zero)
        
        iconImageView.image = icon
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        
        let mainStackView = UIStackView(arrangedSubviews: [iconImageView, labelStackView, checkmarkImageView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
