//
//  ViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nowInCinemaLabel: UILabel = {
        let label = UILabel()
        label.text = "Now in Cinema"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let upcomingMovieLabel: UILabel = {
        let label = UILabel()
        label.text = "Coming soon"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let upcomingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var movies = [MockMovie]()
    private var upcomingMovies = [MockMovie]()
    private let viewModel = HomeViewModel()
    private var selectedDate: Date?
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelDelegate()
        viewModel.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupViewModelDelegate()
        setupBackground()
        setupScrollView()
        setupCollectionView()
        setupUpcomingCollectionView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollStackViewContainer)
        scrollStackViewContainer.addArrangedSubview(nowInCinemaLabel)
        scrollStackViewContainer.addArrangedSubview(collectionView)
        scrollStackViewContainer.addArrangedSubview(upcomingMovieLabel)
        scrollStackViewContainer.addArrangedSubview(upcomingCollectionView)
    }
    
    private func setupCollectionView() {
        collectionView.register(NowInCinemasCollectionViewCell.self, forCellWithReuseIdentifier: "NowInCinemasCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupUpcomingCollectionView() {
        upcomingCollectionView.register(UpcomingCollectionViewCell.self, forCellWithReuseIdentifier: "UpcomingCollectionViewCell")
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.delegate = self
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
            
            collectionView.heightAnchor.constraint(equalToConstant: 320),
            upcomingCollectionView.heightAnchor.constraint(equalToConstant: 320)
            
        ])
    }
}

// MARK: - CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return movies.count
        } else if collectionView == self.upcomingCollectionView {
            return upcomingMovies.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //    print("Configuring cell at index \(indexPath.item)")
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowInCinemasCollectionViewCell", for: indexPath) as? NowInCinemasCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: movies[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCollectionViewCell", for: indexPath) as? UpcomingCollectionViewCell
            else {
                return UICollectionViewCell()
            }
                cell.configure(with: upcomingMovies[indexPath.row])
            return cell
        }
    }
}

// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            viewModel.didSelectMovie(at: indexPath)
        } else if collectionView == upcomingCollectionView {
            viewModel.didSelectUpcomingMovie(at: indexPath)
        }
    }
}
// MARK: - CollectionView FlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + flowLayout.minimumInteritemSpacing
        
        let width = Int((collectionView.bounds.width - totalSpace) / 2)
        let height = 278
        
        return CGSize(width: width, height: height)
        
    }
}
// MARK: - MoviesListViewModelDelegate
extension HomeViewController: MoviesListViewModelDelegate {
    func moviesFetched(_ movies: [MockMovie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("error")
    }

    func navigateToMovieDetails(with movieId: Int) {
        if let selectedMovie = movies.first(where: { $0.id == movieId }) {
            BookingManager.shared.selectedMockMovie = selectedMovie
            BookingManager.shared.selectedDate = selectedDate
        }
        NavigationManager.shared.navigateToMovieDetails(from: self, movieId: movieId)
    }
    
    func navigateToUpcomingMovieDetails(with movieId: Int) {
        
        let upcomingDetailsVC = UpcomingMoviesDetailsViewController(movieId: movieId)
        navigationController?.pushViewController(upcomingDetailsVC, animated: true)
    }
    
    func upcomingMoviesFetched(_ movies: [MockMovie]) {
        self.upcomingMovies = movies
        DispatchQueue.main.async {
            self.upcomingCollectionView.reloadData()
        }
    }
}

