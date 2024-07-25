//
//  PaymentOptionsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import UIKit

final class PaymentOptionsViewController: UIViewController {
    
    // MARK: - Properties
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment method"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let creditCardOption: PaymentOptionView = {
        let view = PaymentOptionView(icon: UIImage(named: "visa_icon"), title: "Credit card", subtitle: "**** **** **** 0805")
        view.isSelected = true
        return view
    }()
    
    private let applePayOption: PaymentOptionView = {
        let view = PaymentOptionView(icon: UIImage(named: "apple_pay_icon"), title: "Apple Pay", subtitle: nil)
        return view
    }()
    
    private let googlePayOption: PaymentOptionView = {
        let view = PaymentOptionView(icon: UIImage(named: "google_pay_icon"), title: "Google Pay", subtitle: nil)
        return view
    }()
    
    private let addNewCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add new card", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(addNewCardTapped), for: .touchUpInside)
        return button
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
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
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(creditCardOption)
        stackView.addArrangedSubview(applePayOption)
        stackView.addArrangedSubview(googlePayOption)
        stackView.addArrangedSubview(addNewCardButton)
        stackView.addArrangedSubview(payButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    @objc private func addNewCardTapped() {
            let addNewCardVC = AddNewCardViewController()
            let navController = UINavigationController(rootViewController: addNewCardVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    
}
