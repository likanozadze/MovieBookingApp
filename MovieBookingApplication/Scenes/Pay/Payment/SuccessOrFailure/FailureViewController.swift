//
//  FailureViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/26/24.
//

import UIKit

final class FailureViewController: UIViewController {
    
    // MARK: - Properties
    private let failureImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment failed"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "We tried to charge your card but, something went wrong. Please update your payment method"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backToCheckoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to checkout", for: .normal)
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
        view.addSubview(failureImageView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(backToCheckoutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            failureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            failureImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            failureImageView.widthAnchor.constraint(equalToConstant: 80),
            failureImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: failureImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            backToCheckoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backToCheckoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backToCheckoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backToCheckoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        backToCheckoutButton.addTarget(self, action: #selector(backToCheckoutTapped), for: .touchUpInside)
    }
    
    @objc private func backToCheckoutTapped() {
        dismiss(animated: true, completion: nil)
    }
}
