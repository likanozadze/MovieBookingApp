//
//  CustomTextField.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import Foundation
import UIKit

final class CustomTextField: UITextField {
    // MARK: - Properties
    private let paddingWidth: CGFloat = 44
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.tintColor = .white
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    // MARK: - Setup
    private func setupTextField() {
        textColor = .white
        font = UIFont.systemFont(ofSize: 16)
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 6
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: bounds.height))
        leftView = paddingView
        leftViewMode = .always
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        tintColor = .white
    }
    
    // MARK: - Configure
    func configure(placeholder: String?, keyboardType: UIKeyboardType, icon: UIImage?) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        )
        self.keyboardType = keyboardType
        iconImageView.image = icon
    }
}
