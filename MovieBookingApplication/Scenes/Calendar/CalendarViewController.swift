//
//  CalendarViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/22/24.
//

import Foundation
import UIKit

final class CalendarViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CalendarViewModel()
    
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(MovieShowtimeCell.self, forCellReuseIdentifier: "MovieShowtimeCell")
        return tableView
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: mainStackView.frame.height)
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupCollectionViews()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(movieTableView)
        
    }
    private func setupCollectionViews() {
        setupCollectionView()
        setupTableView()
    }
    
    private func setupCollectionView() {
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.rowHeight = 100
        movieTableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        movieTableView.separatorStyle = .none
      
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            collectionView.heightAnchor.constraint(equalToConstant: 60),
            collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            movieTableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            movieTableView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }  
}
extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
            return UICollectionViewCell()
        }
        let date = viewModel.dates[indexPath.item]
        cell.configure(for: date)
        cell.delegate = self
        return cell
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let selectedDate = viewModel.dates[indexPath.item]
            
            print("Date cell selected: \(DateFormatter.formattedDate(date: selectedDate, format: "yyyy-MM-dd"))")
        }
    }
}

extension CalendarViewController: DateCollectionViewCellDelegate {
    func dateButtonTapped(date: Date) {
        viewModel.dateSelected(date)
        print("Date cell selected: \(DateFormatter.formattedDate(date: date, format: "yyyy-MM-dd"))")
    }
    
}
extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesByShowtime.values.flatMap { $0 }.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieShowtimeCell", for: indexPath) as? MovieShowtimeCell,
              let movieShowtime = viewModel.getShowtimeForIndexPath(indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: movieShowtime)
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedShowtime = viewModel.getShowtimeForIndexPath(indexPath) else { return }
        navigateToSeatSelection(for: selectedShowtime)
    }

    private func navigateToSeatSelection(for showtime: MovieShowtime) {
        BookingManager.shared.selectedMockMovie = showtime.movie
        BookingManager.shared.selectedTimeSlot = MockTimeSlot(time: showtime.time, price: showtime.price)
        
        let seatsViewModel = SeatsViewModel(
            selectedDate: BookingManager.shared.selectedDate ?? Date(),
            selectedTimeSlot: BookingManager.shared.selectedTimeSlot!,
            dates: viewModel.dates,
            timeSlots: showtime.movie.availableCinemas.flatMap { $0.timeSlots },
            movie: BookingManager.shared.selectedMockMovie!
        )
        
        let seatsViewController = SeatsViewController(viewModel: seatsViewModel)
        navigationController?.pushViewController(seatsViewController, animated: true)
    }
}
