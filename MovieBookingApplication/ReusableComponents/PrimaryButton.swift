//
//  PrimaryButton.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/15/24.
//

import UIKit


enum ButtonStyle {
    case primary
    case secondary
}

protocol ReusableButtonDelegate: AnyObject {
    func buttonTapped(sender: UIButton)
}

final class ReusableButton: UIButton {
    
    weak var delegate: ReusableButtonDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

    }
    
    func setStyle(_ style: ButtonStyle) {
        switch style {
        case .primary:
            backgroundColor = .customSecondaryColor
            setTitleColor(.white, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            titleLabel?.textAlignment = .center
        case .secondary:
            backgroundColor = .customSecondaryColor
            setTitleColor(.white, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            titleLabel?.textAlignment = .center
            
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleButtonTap() {
        delegate?.buttonTapped(sender: self)
    }
}
