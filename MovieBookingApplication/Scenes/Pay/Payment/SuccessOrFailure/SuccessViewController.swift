//
//  SuccessViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/26/24.
//

import UIKit

final class SuccessViewController: UIViewController {
    
    // MARK: - Properties
    
    private let successImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment successful"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Show your tickets upon entering the Cinema hall\nand pick up your snacks at the Cinemabar"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goToTicketsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check your tickets", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .black
    }
    
    private func setupSubviews() {
        view.addSubview(successImageView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(goToTicketsButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            successImageView.widthAnchor.constraint(equalToConstant: 80),
            successImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            goToTicketsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            goToTicketsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goToTicketsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            goToTicketsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        goToTicketsButton.addTarget(self, action: #selector(goToTicketsTapped), for: .touchUpInside)
    }
    
    @objc private func goToTicketsTapped() {
        dismiss(animated: true) {
        }
    }
}
