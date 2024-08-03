//
//  PaymentOptionsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.

import UIKit

final class PaymentOptionsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = PaymentOptionsViewModel()
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
        return button
    }()
    
    private let payButton: ReusableButton = {
        let button = ReusableButton(title: "Pay", hasBackground: false, fontSize: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var cardOptionViews: [PaymentOptionView] = []
    
    weak var delegate: PaymentOptionsViewModelDelegate?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.delegate = self
        viewModel.loadSavedCards()
    }
    
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupButtonAction()
        setupPayButtonAction()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
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
    
    private func setupButtonAction() {
        addNewCardButton.addTarget(self, action: #selector(addNewCardTapped), for: .touchUpInside)
    }
    
    private func setupPayButtonAction() {
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
    }
    
    private func updateCardOptionsUI() {
        cardOptionViews.forEach { $0.removeFromSuperview() }
        cardOptionViews.removeAll()
        
        for (index, card) in viewModel.savedCards.enumerated() {
            let cardOptionView = PaymentOptionView(icon: UIImage(named: card.brand.rawValue + "_icon"),
                                                   title: "\(card.brand.rawValue.capitalized) Card",
                                                   subtitle: "**** **** **** \(card.cardNumber.suffix(4))")
            cardOptionView.tag = index
            cardOptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardOptionTapped(_:))))
            
            cardOptionViews.append(cardOptionView)
            stackView.insertArrangedSubview(cardOptionView, at: index + 1)
        }
        
        updateSelectedCard()
    }
    
    private func updateSelectedCard() {
        cardOptionViews.forEach { $0.isSelected = false }
        if let selectedIndex = viewModel.selectedCardIndex {
            cardOptionViews[selectedIndex].isSelected = true
        }
    }
    
    @objc private func cardOptionTapped(_ gesture: UITapGestureRecognizer) {
        guard let selectedView = gesture.view as? PaymentOptionView else { return }
        viewModel.selectCard(at: selectedView.tag)
        updateSelectedCard()
    }
    
    @objc private func addNewCardTapped() {
        let addNewCardVC = AddNewCardViewController()
        addNewCardVC.delegate = self
        let navController = UINavigationController(rootViewController: addNewCardVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func payButtonTapped() {
        print("Debug - Before payment processing:")
        print(BookingManager.shared.getBookingSummary())
        viewModel.processPayment()
    }
}

extension PaymentOptionsViewController: PaymentOptionsViewModelDelegate {
    func didUpdateCardOptions() {
        updateCardOptionsUI()
    }
    func didProcessPayment(success: Bool, message: String) {
        if success {
            let successVC = SuccessViewController()
            BookingManager.shared.completeBooking()
            successVC.modalPresentationStyle = .fullScreen
            self.dismiss(animated: true) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    if let topController = window.rootViewController {
                        topController.present(successVC, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let failureVC = FailureViewController()
            failureVC.modalPresentationStyle = .fullScreen
            self.present(failureVC, animated: true, completion: nil)
        }
    }
    }
extension PaymentOptionsViewController: AddNewCardViewControllerDelegate {
    func didAddNewCard() {
        viewModel.loadSavedCards()
    }
}
