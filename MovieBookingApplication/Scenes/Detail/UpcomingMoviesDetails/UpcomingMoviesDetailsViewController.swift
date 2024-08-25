//
//  UpcomingMoviesDetailsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/28/24.
//

import UIKit

class UpcomingMoviesDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var movies = [MockMovie]()
    private let dateManager = DateManager.shared
    private var viewModel: UpcomingMoviesDetailsViewModel
    
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
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    
    private lazy var movieDescriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieDescriptionLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let remindMeButton: ReusableButton = {
        let button = ReusableButton(title: "Remind me", hasBackground: false, fontSize: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    // MARK: - Init
    init(movieId: Int) {
        viewModel = DefaultUpcomingMoviesDetailsViewModel(movieId: movieId)
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
        mainStackView.addArrangedSubview(movieLabel)
        mainStackView.addArrangedSubview(releaseLabel)
        mainStackView.addArrangedSubview(remindMeButton)
        mainStackView.addArrangedSubview(movieDescriptionStackView)

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
            
            remindMeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
    // MARK: - MovieDetailsViewModelDelegate
extension UpcomingMoviesDetailsViewController: UpcomingMoviesDetailsViewModelDelegate {
    func moviesDetailsFetched(_ movie: MockMovie) {
        movieLabel.text = movie.title
        releaseLabel.text = "Release date: \(movie.releaseDate)"
        descriptionLabel.text = movie.overview
    }
    
    func showError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func movieImageFetched(_ image: UIImage) {
        movieImageView.image = image
    }
}
