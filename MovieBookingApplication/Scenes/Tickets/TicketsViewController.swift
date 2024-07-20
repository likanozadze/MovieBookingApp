//
//  TicketsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class TicketsViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var foodSections: [(food: Food, sizes: [FoodSize])] = []
    private var filteredFoodSections: [(food: Food, sizes: [FoodSize])] = []
    
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
        filterFoodItems(for: sender.selectedSegmentIndex)
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FoodItemCell.self, forCellReuseIdentifier: "FoodItemCell")
        return tableView
    }()
    
    private let foodItems: [Food] = FoodData.generateFakeData()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFoodSections()
        setup()
        tableView.reloadData()
        view.backgroundColor = UIColor(red: 26/255.0, green: 34/255.0, blue: 50/255.0, alpha: 1)
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupScrollView()
        setupSubviews()
        setupTableView()
        setupConstraints()
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(contentSegmentedControl)
        scrollStackViewContainer.addArrangedSubview(tableView)
    }
    
    private func prepareFoodSections() {
        foodSections = foodItems.map { food in
            let standardSizes = ["Small", "Medium", "Large"]
            let allSizes = standardSizes.map { sizeName -> FoodSize in
                if let existingSize = food.sizes.first(where: { $0.name == sizeName }) {
                    return existingSize
                } else {
                    return FoodSize(name: sizeName, priceModifier: 0.0)
                }
            }
            return (food: food, sizes: allSizes)
        }
        filterFoodItems(for: 0)
    }
    
    private func filterFoodItems(for segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            filteredFoodSections = foodSections.filter { $0.food.name.lowercased().contains("cola") }
        case 1:
            filteredFoodSections = foodSections.filter { $0.food.name.lowercased().contains("popcorn") }
        case 2: 
            filteredFoodSections = foodSections.filter { $0.food.name.lowercased().contains("nachos") }
        default:
            filteredFoodSections = foodSections
        }
        tableView.reloadData()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            contentSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
}

// MARK: - UITableViewDataSource
extension TicketsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredFoodSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFoodSections[section].sizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as? FoodItemCell else {
            fatalError("Unable to dequeue FoodItemCell")
        }
        
        let foodItem = filteredFoodSections[indexPath.section].food
        let size = filteredFoodSections[indexPath.section].sizes[indexPath.row]
        cell.configure(with: foodItem, size: size)
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredFoodSections[section].food.name
    }
}
// MARK: - UITableViewDelegate

extension TicketsViewController: UITableViewDelegate {
  
}
