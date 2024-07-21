//
//  SeatsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/16/24.
//

import UIKit
import SwiftUI

final class SeatsViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // MARK: - Properties
    
    private let viewModel: SeatsViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var timeSlotCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var timeAndDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateCollectionView, timeSlotCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let selectSeatsLabel: UILabel = {
        let label = UILabel()
        label.text = "Select seats"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let screenLabel: UILabel = {
        let label = UILabel()
        label.text = "screen"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let arcView: ArcView = {
        let view = ArcView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var selectSeatsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectSeatsLabel, arcView, screenLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nextButton: ReusableButton = {
        let button = ReusableButton(title: "Next", hasBackground: false, fontSize: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(viewModel: SeatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCollectionViews()
        viewModel.initializeSeats()
        setupScrollView()
        nextButton.addTarget(self, action: #selector(navigateToFoodViewController), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupCollectionViews() {
        setupDateCollectionView()
        setupTimeSlotCollectionView()
        setupSeatsCollectionView()
    }
    
    private func setupDateCollectionView() {
        dateCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
    }
    
    private func setupTimeSlotCollectionView() {
        timeSlotCollectionView.register(TimeSlotCollectionViewCell.self, forCellWithReuseIdentifier: "TimeSlotCollectionViewCell")
        timeSlotCollectionView.dataSource = self
        timeSlotCollectionView.delegate = self
    }
    
    private func setupSeatsCollectionView() {
        collectionView.register(SeatCell.self, forCellWithReuseIdentifier: "seatCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        view.addSubview(nextButton)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(timeAndDateStackView)
        mainStackView.addArrangedSubview(selectSeatsStackView)
        mainStackView.addArrangedSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            dateCollectionView.heightAnchor.constraint(equalToConstant: 80),
            timeSlotCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            selectSeatsStackView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor),
            selectSeatsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            nextButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedDateIndex = viewModel.selectedDateIndex {
            let indexPath = IndexPath(item: selectedDateIndex, section: 0)
            dateCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        
        if let selectedTimeSlotIndex = viewModel.selectedTimeSlotIndex {
            let indexPath = IndexPath(item: selectedTimeSlotIndex, section: 0)
            timeSlotCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - CollectionView DataSource
extension SeatsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return viewModel.rowsPerSection.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case dateCollectionView:
            return viewModel.dates.count
        case timeSlotCollectionView:
            return viewModel.timeSlots.count
        default:
            return viewModel.rowsPerSection[section]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case dateCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
            let date = viewModel.dates[indexPath.item]
            cell.configure(for: date, isSelected: indexPath.item == viewModel.selectedDateIndex)
            return cell
        case timeSlotCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as! TimeSlotCollectionViewCell
            let timeSlot = viewModel.timeSlots[indexPath.item]
            let formattedTime = DateFormatter.formattedDate(date: timeSlot.startTime, format: "HH:mm")
            let priceString = timeSlot.ticketPrices.first?.price.formatPrice(currency: timeSlot.ticketPrices.first?.currency ?? "USD") ?? "N/A"
            cell.configure(time: formattedTime, price: priceString, isSelected: indexPath.item == viewModel.selectedTimeSlotIndex)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCell", for: indexPath) as! SeatCell
            if let seat = viewModel.getSeat(for: indexPath) {
                cell.configure(withSeat: seat)
            }
            return cell
        }
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case dateCollectionView:
            viewModel.selectDate(at: indexPath.item)
            dateCollectionView.reloadData()
        case timeSlotCollectionView:
            viewModel.selectTimeSlot(at: indexPath.item)
            timeSlotCollectionView.reloadData()
        default:
            guard let cell = collectionView.cellForItem(at: indexPath) as? SeatCell else { return }
            cell.handleTap()
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - CollectionView FlowLayout
extension SeatsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case dateCollectionView:
            return CGSize(width: 80, height: 60)
        case timeSlotCollectionView:
            return CGSize(width: 80, height: 100)
        default:
            return CGSize(width: 40, height: 40)
        }
    }
    
    @objc private func navigateToFoodViewController() {
        if !viewModel.canProceedToFoodSelection() {
            AlertManager.shared.showAlert(from: self, type: .selectionIncomplete)
            return
        }
        let foodSelectionSheet = FoodSelectionSheet(presentingViewController: self)
        let hostingController = UIHostingController(rootView: foodSelectionSheet)
        hostingController.modalPresentationStyle = .pageSheet
        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(hostingController, animated: true, completion: nil)
    }
}
