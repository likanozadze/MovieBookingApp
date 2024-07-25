//
//  TicketsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class FoodViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Properties
    
    private let viewModel: FoodViewModel
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var contentSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Drinks", "Popcorn", "Food"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = .customSecondaryColor
        segmentedControl.selectedSegmentTintColor = .customAccentColor
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        return segmentedControl
    }()
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.filterFoodItems(for: sender.selectedSegmentIndex)
        tableView.reloadData()
    }
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FoodItemCell.self, forCellReuseIdentifier: "FoodItemCell")
        return tableView
    }()
    
    private let chooseSnacksButton: ReusableButton = {
        let button = ReusableButton(title: "Choose snacks", hasBackground: false, fontSize: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .customAccentColor
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Init
    init() {
        self.viewModel = FoodViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.filterFoodItems(for: contentSegmentedControl.selectedSegmentIndex)
        tableView.reloadData()
        updateBadge()
        
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSubviews()
        setupTableView()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(contentSegmentedControl)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(chooseSnacksButton)
        view.addSubview(badgeLabel)
        chooseSnacksButton.addTarget(self, action: #selector(navigateToOrder), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            contentSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300),
            
            chooseSnacksButton.heightAnchor.constraint(equalToConstant: 60),
            chooseSnacksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chooseSnacksButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chooseSnacksButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            badgeLabel.topAnchor.constraint(equalTo: contentSegmentedControl.topAnchor, constant: -5),
            badgeLabel.trailingAnchor.constraint(equalTo: contentSegmentedControl.trailingAnchor, constant: 5),
            badgeLabel.widthAnchor.constraint(equalToConstant: 20),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func updateBadge() {
        let count = viewModel.totalSelectedItems()
        badgeLabel.isHidden = count == 0
        badgeLabel.text = "\(count)"
        
        if count > 0 {
            contentSegmentedControl.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        } else {
            contentSegmentedControl.layoutMargins = .zero
        }
        contentSegmentedControl.setNeedsLayout()
        
    }
}
// MARK: - UITableViewDataSource
extension FoodViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as? FoodItemCell else {
            fatalError("Unable to dequeue FoodItemCell")
        }
        let foodManager = FoodManager.shared
        let foodSection = foodManager.filteredFoodSections[indexPath.section]
        let food = foodSection.food
        let size = foodSection.sizes[indexPath.row]
        let quantity = viewModel.quantity(for: food, size: size)
        
        cell.configure(with: food, size: size, quantity: quantity)
        
        cell.delegate = self
        return cell
    }
    
}
// MARK: - UITableViewDelegate

extension FoodViewController: FoodCollectionViewCellDelegate {
    func addProduct(for cell: FoodItemCell?) {
        print("Add product button tapped")
        guard let cell = cell, let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.increaseQuantity(at: indexPath)
        tableView.reloadData()
        updateBadge()
    }
    
    func removeProduct(for cell: FoodItemCell?) {
        guard let cell = cell, let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.decreaseQuantity(at: indexPath)
        tableView.reloadData()
        updateBadge()
    }
    
    // MARK: - Actions

    @objc private func navigateToOrder() {
        let bookingManager = BookingManager.shared
        bookingManager.calculateTotalPrice()
        
        let orderViewModel = OrderViewModel()
        let orderViewController = OrderViewController(viewModel: orderViewModel)
        NavigationManager.shared.navigateToOrderViewController(from: self, with: orderViewController)
    }
}
