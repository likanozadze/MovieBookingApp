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
    
    private let selectedDate: Date
    private let selectedTimeSlot: TimeSlot
    private let dates: [Date]
    private let timeSlots: [TimeSlot]
    private let seatManager = SeatManager.shared
    private let rowsPerSection = [7, 7, 7, 7, 7, 7]
    
    // MARK: - Init
    
    init(selectedDate: Date, selectedTimeSlot: TimeSlot, dates: [Date], timeSlots: [TimeSlot]) {
        self.selectedDate = selectedDate
        self.selectedTimeSlot = selectedTimeSlot
        self.dates = dates
        self.timeSlots = timeSlots
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
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    private func setupCollectionViews() {
        setupDateCollectionView()
        setupTimeSlotCollectionView()
        setupSeatsCollectionView()
    }
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
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

            dateCollectionView.heightAnchor.constraint(equalToConstant: 60),
            timeSlotCollectionView.heightAnchor.constraint(equalToConstant: 100),

            timeAndDateStackView.heightAnchor.constraint(equalToConstant: 150),

            selectSeatsLabel.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor),
                  selectSeatsLabel.heightAnchor.constraint(equalToConstant: 40),


            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }

    func initializeSeats() {
        let numberOfSections = rowsPerSection.count
        seatManager.setSeats(for: numberOfSections, rowsPerSection: rowsPerSection)
    }
}
// MARK: - UICollectionViewDataSource

extension SeatsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return rowsPerSection.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dateCollectionView {
            print("Number of dates: \(dates.count)")
            return dates.count
        } else if collectionView == timeSlotCollectionView {
            print("Number of time slots: \(timeSlots.count)")
            return timeSlots.count
        } else {
            return rowsPerSection[section]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dateCollectionView {
            print("Configuring date cell at index \(indexPath.item)")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
                return UICollectionViewCell()
            }
            let date = dates[indexPath.item]
            cell.configure(for: date)
            cell.isSelected = date == selectedDate
            return cell
        } else if collectionView == timeSlotCollectionView {
            print("Configuring time slot cell at index \(indexPath.item)")
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as? TimeSlotCollectionViewCell else {
                return UICollectionViewCell()
            }
            let timeSlot = timeSlots[indexPath.item]
            let formattedTime = DateFormatter.formattedDate(date: timeSlot.startTime, format: "HH:mm")
            let priceString = formatPrice(timeSlot.ticketPrices.first?.price ?? 0, currency: timeSlot.ticketPrices.first?.currency ?? "USD")
            let isSelected = timeSlot == selectedTimeSlot
            cell.configure(time: formattedTime, price: priceString, isSelected: isSelected)
            return cell
            
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCell", for: indexPath) as? SeatCell else {
                fatalError("Could not dequeue seat cell")
            }
            guard let seat = seatManager.getSeat(by: indexPath.section, row: indexPath.row) else {
                print("Seat not found at indexPath: \(indexPath)")
                return cell
            }
            cell.configure(withSeat: seat)
            return cell
        }
    }
    
    private func formatPrice(_ price: Double, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            return formattedPrice
        } else {
            return String(format: "%.2f %@", price, currency)
        }
    }
}

extension SeatsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionView {
            return CGSize(width: 80, height: 60)
        } else if collectionView == timeSlotCollectionView {
            return CGSize(width: 80, height: 100)
        } else {
            return CGSize(width: 40, height: 40)
        }
    }
}
