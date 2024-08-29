//
//  CinemaViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/26/24.
//


import UIKit

final class CinemaViewController: UIViewController {
    
    private let tableView = UITableView()
    private var cinemas: [Cinema] = []
    private let homeViewModel: HomeViewModel
       
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
       init(homeViewModel: HomeViewModel) {
           self.homeViewModel = homeViewModel
           super.init(nibName: nil, bundle: nil)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        homeViewModel.fetchMovies()
        fetchCinemas()
    }
    
    private func setup() {
       setupBackground()
        setupTableView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
        tableView.backgroundColor = .clear
    }
    
    
    private func setupTableView() {
        tableView.register(CinemaCell.self, forCellReuseIdentifier: "CinemaCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
     
    }

        private func setupSubviews() {
            view.addSubview(mainStackView)
            mainStackView.addArrangedSubview(tableView)
        }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func fetchCinemas() {
        Task {
            do {
                let movies = try await NetworkManager.shared.fetchFromMockAPI()
                let uniqueCinemas = Set(movies.flatMap { $0.availableCinemas })
                
                DispatchQueue.main.async {
                    self.cinemas = Array(uniqueCinemas)
                    self.tableView.reloadData()
                }
             
                self.cinemas.forEach { cinema in
                }
            } catch {
                print("Failed to fetch cinemas: \(error)")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CinemaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cinemas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath) as! CinemaCell
        let cinema = cinemas[indexPath.row]
        cell.configure(with: cinema)
        return cell
    }
}
extension CinemaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCinema = cinemas[indexPath.row]
        let filteredMovies = homeViewModel.getMovies(for: selectedCinema.cinemaId)
        let moviesForCinemaVC = MoviesForCinemaViewController(movies: filteredMovies, cinema: selectedCinema)
        navigationController?.pushViewController(moviesForCinemaVC, animated: true)
    }
    
}
