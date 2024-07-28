//
//  EmptyStateViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/28/24.
//
import Foundation
import UIKit
import Lottie

class EmptyStateViewController: UIViewController {
    // MARK: - Properties
    private var animationView: LottieAnimationView!
    
    private let emptyStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let emptyStateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        style.alignment = .center
        return style
    }()
    
    private lazy var emptyStateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        
        let attributedText = NSMutableAttributedString(string: "")
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        label.attributedText = attributedText
        return label
    }()
    
    // MARK: - Init
    init(title: String, description: String, animationName: String) {
        super.init(nibName: nil, bundle: nil)
        emptyStateTitleLabel.text = title
        let attributedText = NSMutableAttributedString(string: description)
        attributedText.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSMakeRange(0, attributedText.length)
        )
        emptyStateDescriptionLabel.attributedText = attributedText
        setupEmptyHistoryAnimationView(animationName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        setupSubviews()
        setupConstraints()
    }
    
    
    private func setupSubviews() {
        view.addSubview(animationView)
        view.addSubview(emptyStateStackView)
        emptyStateStackView.addArrangedSubview(emptyStateTitleLabel)
        emptyStateStackView.addArrangedSubview(emptyStateDescriptionLabel)
        print("Stack view is being added: \(emptyStateStackView)")
    }
    
    private func setupEmptyHistoryAnimationView(_ animationName: String) {
        animationView = .init(name: animationName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.translatesAutoresizingMaskIntoConstraints = false // Important!
        view.addSubview(animationView)
        animationView.play()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyStateStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emptyStateStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.bottomAnchor.constraint(equalTo: emptyStateStackView.topAnchor, constant: -20),
            animationView.widthAnchor.constraint(lessThanOrEqualToConstant: 240),
            animationView.heightAnchor.constraint(lessThanOrEqualToConstant: 240)
        ])
    }
}
