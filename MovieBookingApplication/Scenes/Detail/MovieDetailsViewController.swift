//
//  MovieDetailsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var movies = [Movie]()
    private var dates: [Date] = []
    private let dateManager = DateManager.shared
    private var viewModel: MovieDetailsViewModel
    private var timeSlots: [TimeSlot] = []
    private var selectedDate: Date?
    private var isTimeSlotCollectionViewHidden = true
    private var selectedTimeSlot: TimeSlot?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let timePriceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let selectSeatsButton: ReusableButton = {
        let button = ReusableButton(title: "Select Seats", hasBackground: false, fontSize: .medium)
      //  button.addTarget(self, action: #selector(handleSelectSeats), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(movieId: Int) {
        viewModel = DefaultMovieDetailsViewModel(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
        fetchDates()
        setupButtonAction()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSubviews()
        setupCollectionViews()
        setupConstraints()
        
    }
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews(){
        view.addSubview(scrollView)
        view.addSubview(selectSeatsButton)
        scrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(movieImageView)
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(timePriceCollectionView)
        timePriceCollectionView.isHidden = true
        
    }
    
    private func setupCollectionViews() {
        setupCollectionView()
        setupTimePriceCollectionView()
    }
    
    
    private func setupCollectionView() {
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    private func setupTimePriceCollectionView() {
        timePriceCollectionView.register(TimeSlotCollectionViewCell.self, forCellWithReuseIdentifier: "TimeSlotCollectionViewCell")
        timePriceCollectionView.dataSource = self
        timePriceCollectionView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            movieImageView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            movieImageView.heightAnchor.constraint(equalToConstant: 240),
            
            collectionView.heightAnchor.constraint(equalToConstant: 60),
            timePriceCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            selectSeatsButton.heightAnchor.constraint(equalToConstant: 60),
            selectSeatsButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            selectSeatsButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            selectSeatsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func toggleTimeSlotCollectionView(for date: Date) {
        if selectedDate == date && !isTimeSlotCollectionViewHidden {
            timePriceCollectionView.isHidden = true
            isTimeSlotCollectionViewHidden = true
            selectedDate = nil
            selectedTimeSlot = nil
            resetTimeSlotSelections()
        } else {
            timePriceCollectionView.isHidden = false
            isTimeSlotCollectionViewHidden = false
            selectedDate = date
            fetchTimeSlots(for: date)
        }
    }
    
    private func resetTimeSlotSelections() {
        for cell in timePriceCollectionView.visibleCells {
            cell.isSelected = false
        }
        selectedTimeSlot = nil
    }
    private func fetchDates() {
        dates = dateManager.fetchDates(numberOfDays: 7)
        collectionView.reloadData()
    }
    
    private func fetchTimeSlots(for selectedDate: Date) {
        viewModel.fetchTimeSlots(for: selectedDate)
    }
}

// MARK: - MovieDetailsViewModelDelegate
extension MovieDetailsViewController: MovieDetailsViewModelDelegate {
    func movieDetailsFetched(_ movie: MovieDetails) {
        Task {
            navigationItem.title = movie.title
        }
    }
    
    func showError(_ error: Error) {
        print("Error")
    }
    
    func movieDetailsImageFetched(_ image: UIImage) {
        Task {
            movieImageView.image = image
        }
    }
    func timeSlotsFetched(_ timeSlots: [TimeSlot]) {
        self.timeSlots = timeSlots
        DispatchQueue.main.async {
            self.timePriceCollectionView.reloadData()
        }
        
    }
}
// MARK: - CollectionView DataSource

extension MovieDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return dates.count
        } else if collectionView == timePriceCollectionView {
            return timeSlots.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
                return UICollectionViewCell()
            }
            let date = dates[indexPath.item]
            cell.configure(for: date)
            cell.delegate = self
            return cell
        } else if collectionView == timePriceCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as? TimeSlotCollectionViewCell else {
                return UICollectionViewCell()
            }
            let timeSlot = timeSlots[indexPath.item]
            let formattedTime = DateFormatter.formattedDate(date: timeSlot.startTime, format: "HH:mm")
            let priceString = timeSlot.ticketPrices.first?.price.formatPrice(currency: timeSlot.ticketPrices.first?.currency ?? "USD") ?? "N/A"
            
            cell.configure(time: formattedTime, price: priceString, isSelected: timeSlot == selectedTimeSlot)
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}


// MARK: - CollectionView FlowLayout
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 80, height: 60)
        } else if collectionView == timePriceCollectionView {
            return CGSize(width: 80, height: 100)
        }
        return CGSize.zero
    }
}

// MARK: - DateCollectionViewCellDelegate
extension MovieDetailsViewController: DateCollectionViewCellDelegate {
    func dateButtonTapped(date: Date) {
        selectedDate = date
        toggleTimeSlotCollectionView(for: date)
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let selectedDate = dates[indexPath.item]
            toggleTimeSlotCollectionView(for: selectedDate)
        } else if collectionView == timePriceCollectionView {
            let selectedTimeSlot = timeSlots[indexPath.item]
            self.selectedTimeSlot = selectedTimeSlot
            timePriceCollectionView.reloadData()
        }
    }
}
extension MovieDetailsViewController: TimeSlotCollectionViewCellDelegate {
    func timeSlotCellTapped(_ cell: TimeSlotCollectionViewCell) {
        if let indexPath = timePriceCollectionView.indexPath(for: cell) {
            let selectedTimeSlot = timeSlots[indexPath.item]
            self.selectedTimeSlot = selectedTimeSlot
        }
    }
    
    
    // MARK: - Actions
    
    private func setupButtonAction() {
        selectSeatsButton.addTarget(self, action: #selector(handleSelectSeats), for: .touchUpInside)
    }

    @objc func handleSelectSeats() {
        guard let selectedDate = selectedDate, let selectedTimeSlot = selectedTimeSlot else {
            AlertManager.shared.showAlert(from: self, type: .selectionIncomplete)
            return
        }
        
        let seatsViewModel = SeatsViewModel(selectedDate: selectedDate, selectedTimeSlot: selectedTimeSlot, dates: dates, timeSlots: timeSlots)
        let seatsViewController = SeatsViewController(viewModel: seatsViewModel)
        navigationController?.pushViewController(seatsViewController, animated: true)
    }
}
