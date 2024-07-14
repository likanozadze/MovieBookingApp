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
    private var viewModel: MovieDetailsViewModel
    private var timeSlots: [TimeSlot] = []
    private var selectedDate: Date?
    private var isTimeSlotCollectionViewHidden = true
    
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
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 210).isActive = true
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
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        fetchDates()
    }
  
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupCollectionView()
        setupScrollView()
        setupSubviews()
        setupConstraints()
        setupTimePriceCollectionView()
        
    }
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(movieImageView)
        scrollStackViewContainer.addArrangedSubview(collectionView)
        scrollStackViewContainer.addArrangedSubview(timePriceCollectionView)
        timePriceCollectionView.isHidden = true
    }
    
    private func setupCollectionView() {
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    // MARK: - Private Methods
    private func setupTimePriceCollectionView() {
        timePriceCollectionView.register(TimeSlotCollectionViewCell.self, forCellWithReuseIdentifier: "TimeSlotCollectionViewCell")
        timePriceCollectionView.dataSource = self
        timePriceCollectionView.delegate = self
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
            
            movieImageView.topAnchor.constraint(equalTo: scrollStackViewContainer.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 210),
            
            collectionView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 60),
            collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(dates.count)),
            
            timePriceCollectionView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            timePriceCollectionView.leadingAnchor.constraint(equalTo: scrollStackViewContainer.leadingAnchor),
            timePriceCollectionView.trailingAnchor.constraint(equalTo: scrollStackViewContainer.trailingAnchor),
            timePriceCollectionView.heightAnchor.constraint(equalToConstant: 60),
            timePriceCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(dates.count)),
            timePriceCollectionView.bottomAnchor.constraint(equalTo: scrollStackViewContainer.bottomAnchor, constant: -16)
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
        let calendar = Calendar.current
        let today = Date()
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
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
                return UICollectionViewCell() // Handle gracefully
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
            let formattedTime = formatDate(timeSlot.startTime)
            let priceString = formatPrice(timeSlot.ticketPrices.first?.price ?? 0, currency: timeSlot.ticketPrices.first?.currency ?? "USD")
            
            cell.configure(time: formattedTime, price: priceString)
            return cell
        }
        return UICollectionViewCell()
    }
    
                private func formatPrice(_ price: Double, currency: String) -> String {
                    return String(format: "%.2f %@", price, currency)
                }
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionView {
            return CGSize(width: 80, height: 60)
        } else if collectionView == timePriceCollectionView {
            return CGSize(width: collectionView.bounds.width, height: 80)
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
