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
    
    
    private let MainStackView: UIStackView = {
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
    // MARK: - Init
    init(movieId: Int) {
        viewModel = DefaultMovieDetailsViewModel(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
        fetchDates()
        setupTimePriceCollectionView()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupCollectionView()
        setupSubviews()
        setupConstraints()
        setupTimePriceCollectionView()
        
    }
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(MainStackView)
        
        MainStackView.addArrangedSubview(movieImageView)
        MainStackView.addArrangedSubview(collectionView)
        MainStackView.addArrangedSubview(timePriceCollectionView)
        timePriceCollectionView.isHidden = true
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
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            MainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            MainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            MainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            MainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            MainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            movieImageView.topAnchor.constraint(equalTo: MainStackView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: MainStackView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: MainStackView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 240),
            
            
            collectionView.heightAnchor.constraint(equalToConstant: 60),
            timePriceCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func toggleTimeSlotCollectionView(for date: Date) {
        if selectedDate == date && !isTimeSlotCollectionViewHidden {
            timePriceCollectionView.isHidden = true
            isTimeSlotCollectionViewHidden = true
            selectedDate = nil
        } else {
            timePriceCollectionView.isHidden = false
            isTimeSlotCollectionViewHidden = false
            selectedDate = date
            fetchTimeSlots(for: date)
        }
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
        timePriceCollectionView.reloadData()
    }
}
// MARK: - UICollectionViewDataSource

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
            guard indexPath.item < dates.count else {
                return UICollectionViewCell()
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
                return UICollectionViewCell()
            }
            let date = dates[indexPath.item]
            cell.configure(for: date)
            cell.delegate = self
            return cell
        } else if collectionView == timePriceCollectionView {
            guard indexPath.item < timeSlots.count else {
                return UICollectionViewCell()
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotCollectionViewCell", for: indexPath) as? TimeSlotCollectionViewCell else {
                return UICollectionViewCell()
            }
            let timeSlot = timeSlots[indexPath.item]
            let formattedTime = DateFormatter.formattedDate(date: timeSlot.startTime, format: "HH:mm")
            let priceString = formatPrice(timeSlot.ticketPrices.first?.price ?? 0, currency: timeSlot.ticketPrices.first?.currency ?? "USD")
            
            cell.configure(time: formattedTime, price: priceString)
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func formatPrice(_ price: Double, currency: String) -> String {
        return String(format: "%.2f %@", price, currency)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: 80, height: 60)
        } else if collectionView == timePriceCollectionView {
            
            //   let width: CGFloat = collectionView.bounds.width * 0.5
            //  let height: CGFloat = 100
            return CGSize(width: 80, height: 100)
            //   return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
    
}

// MARK: - DateCollectionViewCellDelegate
extension MovieDetailsViewController: DateCollectionViewCellDelegate {
    func dateButtonTapped(date: Date) {
        toggleTimeSlotCollectionView(for: date)
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let selectedDate = dates[indexPath.item]
            toggleTimeSlotCollectionView(for: selectedDate)
        }
    }
}

