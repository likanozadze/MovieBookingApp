//
//  MovieDetailsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    // MARK: - UI Components
    
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
    
    private var dates: [Date] = []
    private var viewModel: MovieDetailsViewModel
    
    // MARK: - Init
    init(movieId: Int) {
        viewModel = DefaultMovieDetailsViewModel(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
        fetchDates()
    }
    
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupCollectionView()
        setupScrollView()
        setupSubviews()
        setupConstraints()
    
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
        
        
    }
    
    private func setupCollectionView() {
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
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
                collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(dates.count))
        ])
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
}
    extension MovieDetailsViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dates.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as? DateCollectionViewCell else {
                return UICollectionViewCell()
            }
            let date = dates[indexPath.item]
            cell.configure(for: date)
            return cell
        }
    }
    extension MovieDetailsViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing
            
            let width = Int((collectionView.bounds.width - totalSpace) / 6)
            let height = 60
            
            return CGSize(width: width, height: height)
            
        }
    }
    
