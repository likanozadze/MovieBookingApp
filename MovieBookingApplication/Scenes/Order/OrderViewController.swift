//
//  OrderViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import UIKit

final class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Properties
    private let viewModel: OrderViewModel
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let seatsLabel: UILabel = {
        let label = UILabel()
        label.text = "Seats"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let seatsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(SeatTableViewCell.self, forCellReuseIdentifier: "SeatTableViewCell")
        return tableView
    }()
    
    private lazy var seatsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [seatsLabel, seatsTableView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let snacksLabel: UILabel = {
        let label = UILabel()
        label.text = "Snacks"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let snacksTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SnackTableViewCell")
        return tableView
    }()
    
    private lazy var snackStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [snacksLabel, snacksTableView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private lazy var totalPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalLabel, priceLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieGenreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [movieTitleLabel, movieGenreLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var movieStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [posterImageView, movieLabelStackView])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    init(viewModel: OrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        updateTotalPrice()
        loadMoviePoster()
        updateMovieInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTotalPrice()
        seatsTableView.reloadData()
        snacksTableView.reloadData()
    }
    
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
    }
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(movieStackView)
        mainStackView.addArrangedSubview(seatsStackView)
        mainStackView.addArrangedSubview(snackStackView)
        mainStackView.addArrangedSubview(totalPriceStackView)
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
            
            movieStackView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            seatsStackView.heightAnchor.constraint(equalToConstant: 150),
            snackStackView.heightAnchor.constraint(equalToConstant: 150),
            
            totalPriceStackView.topAnchor.constraint(equalTo: snackStackView.bottomAnchor, constant: 16),
            totalPriceStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            totalPriceStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            totalPriceStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func setupTableView() {
        seatsTableView.dataSource = self
        seatsTableView.delegate = self
        snacksTableView.dataSource = self
        snacksTableView.delegate = self
    }
    
    private func updateTotalPrice() {
        viewModel.recalculateTotalPrice()
        let totalPrice = viewModel.totalPrice
        priceLabel.text = "$\(String(format: "%.2f", totalPrice))"
    }
    private func loadMoviePoster() {
        guard let movie = viewModel.selectedMovie else {
            self.posterImageView.image = UIImage(named: "placeholder")
            return
        }
        let posterPath = movie.posterPath
        ImageLoader.loadImage(from: posterPath) { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.posterImageView.image = image
                } else {
                    self?.posterImageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    private func updateMovieInfo() {
        movieTitleLabel.text = viewModel.movieTitle
        movieGenreLabel.text = viewModel.movieGenres
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == seatsTableView {
            return viewModel.selectedSeats.count
        } else if tableView == snacksTableView {
            return viewModel.selectedOrderedFood.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == seatsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeatTableViewCell", for: indexPath) as? SeatTableViewCell ?? SeatTableViewCell(style: .default, reuseIdentifier: "SeatTableViewCell")
            let seat = viewModel.selectedSeats[indexPath.row]
            
            if let showTime = viewModel.selectedTimeSlot?.showTime,
               let ticketPrices = viewModel.selectedTimeSlot?.ticketPrices {
                cell.configure(with: seat, showTime: showTime, ticketPrices: ticketPrices)
            } else {
                cell.configure(with: seat, showTime: .afternoon1, ticketPrices: [])
            }
            return cell
        } else if tableView == snacksTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SnackTableViewCell", for: indexPath) as? SnackTableViewCell ?? SnackTableViewCell(style: .default, reuseIdentifier: "SnackTableViewCell")
            let orderedFood = viewModel.selectedOrderedFood[indexPath.row]
            let price = orderedFood.food.price + orderedFood.size.priceModifier
            cell.configure(with: orderedFood.food, size: orderedFood.size, price: price, quantity: orderedFood.quantity)
            return cell
        }
        return UITableViewCell()
    }
}
