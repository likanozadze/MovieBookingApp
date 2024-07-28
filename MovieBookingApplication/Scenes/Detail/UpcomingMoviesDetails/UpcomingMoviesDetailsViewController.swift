//
//  UpcomingMoviesDetailsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/28/24.
//

import UIKit

class UpcomingMoviesDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var movies = [Movie]()
    private var dates: [Date] = []
    private let dateManager = DateManager.shared
    private var viewModel: MovieDetailsViewModel
    private var timeSlots: [TimeSlot] = []
    private var isTimeSlotCollectionViewHidden = true
    private let bookingManager = BookingManager.shared
    
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
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.viewDidLoad()
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
    
    private func setupSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(movieImageView)

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
            
            
        ])
    }
    
}
    // MARK: - MovieDetailsViewModelDelegate
    extension UpcomingMoviesDetailsViewController: MovieDetailsViewModelDelegate {
        func movieDetailsFetched(_ movie: MovieDetails) {
            Task {
                
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
    
            }
            
        }
    }

