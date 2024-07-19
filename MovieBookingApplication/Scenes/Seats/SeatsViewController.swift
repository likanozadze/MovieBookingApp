//
//  SeatsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/16/24.
//


import UIKit

final class SeatsViewController: UIViewController {
    
    // MARK: - Properties
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
        return label
    }()
    
    private let checkoutButton: ReusableButton = {
        let button = ReusableButton(title: "Checkout", hasBackground: false, fontSize: .medium)
        //   button.addTarget(self, action: #selector(handleSelectSeats), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let selectedDate: Date
    private let selectedTimeSlot: TimeSlot
    private let dates: [Date]
    private let timeSlots: [TimeSlot]
    private let seatManager = SeatManager.shared
    private let rowsPerSection = [7, 7, 7, 7, 7, 7]
    private var selectedDateIndex: Int?
    private var selectedTimeSlotIndex: Int?
    
    // MARK: - Init
    init(selectedDate: Date, selectedTimeSlot: TimeSlot, dates: [Date], timeSlots: [TimeSlot]) {
        self.selectedDate = selectedDate
        self.selectedTimeSlot = selectedTimeSlot
        self.dates = dates
        self.timeSlots = timeSlots
        self.selectedDateIndex = dates.firstIndex(of: selectedDate)
        self.selectedTimeSlotIndex = timeSlots.firstIndex(where: { $0.startTime == selectedTimeSlot.startTime })
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
        initializeSeats()
        setupScrollView()
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
        view.addSubview(checkoutButton)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(timeAndDateStackView)
        mainStackView.addArrangedSubview(selectSeatsLabel)
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
            
            dateCollectionView.heightAnchor.constraint(equalToConstant: 100),
            timeSlotCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            selectSeatsLabel.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor),
            selectSeatsLabel.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            checkoutButton.heightAnchor.constraint(equalToConstant: 60),
            checkoutButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func initializeSeats() {
        let numberOfSections = rowsPerSection.count
        seatManager.setSeats(for: numberOfSections, rowsPerSection: rowsPerSection)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedDateIndex = selectedDateIndex {
            let indexPath = IndexPath(item: selectedDateIndex, section: 0)
            dateCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        
        if let selectedTimeSlotIndex = selectedTimeSlotIndex {
            let indexPath = IndexPath(item: selectedTimeSlotIndex, section: 0)
            timeSlotCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}
// MARK: - CollectionView DataSource

extension SeatsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return rowsPerSection.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case dateCollectionView:
            return dates.count
        case timeSlotCollectionView:
            return timeSlots.count
        default:
            return rowsPerSection[section]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case dateCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
            let date = dates[indexPath.item]
            cell.configure(for: date, isSelected: indexPath.item == selectedDateIndex)
            return cell
        case timeSlotCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as! TimeSlotCollectionViewCell
            let timeSlot = timeSlots[indexPath.item]
            let formattedTime = DateFormatter.formattedDate(date: timeSlot.startTime, format: "HH:mm")
            let priceString = timeSlot.ticketPrices.first?.price.formatPrice(currency: timeSlot.ticketPrices.first?.currency ?? "USD") ?? "N/A"
            cell.configure(time: formattedTime, price: priceString, isSelected: indexPath.item == selectedTimeSlotIndex)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCell", for: indexPath) as! SeatCell
            if let seat = seatManager.getSeat(by: indexPath.section, row: indexPath.row) {
                cell.configure(withSeat: seat)
            }
            return cell
        }
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case dateCollectionView:
            selectedDateIndex = indexPath.item
            dateCollectionView.reloadData()
        case timeSlotCollectionView:
            selectedTimeSlotIndex = indexPath.item
            timeSlotCollectionView.reloadData()
        default:
            break
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
}
