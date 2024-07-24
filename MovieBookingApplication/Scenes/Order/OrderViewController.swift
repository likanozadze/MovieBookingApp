//
//  OrderViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

//import UIKit
//
//final class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    // MARK: - Properties
//    private let viewModel: OrderViewModel
//    private let mainStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.isLayoutMarginsRelativeArrangement = true
//        return stackView
//    }()
//    
//    private let seatsTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .clear
//        tableView.showsVerticalScrollIndicator = false
//        tableView.register(SeatTableViewCell.self, forCellReuseIdentifier: "SeatTableViewCell")
//        return tableView
//    }()
//    
//    private let snacksTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .clear
//        tableView.showsVerticalScrollIndicator = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SnackTableViewCell")
//        return tableView
//    }()
//    
//    // MARK: - Init
//    init(viewModel: OrderViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setup()
//        setupTableView()
//    }
//    
//    private func setup() {
//        setupBackground()
//        setupSubviews()
//        setupConstraints()
//    }
//    private func setupBackground() {
//        view.backgroundColor = .customBackgroundColor
//    }
//    
//    private func setupSubviews() {
//        view.addSubview(mainStackView)
//        mainStackView.addArrangedSubview(seatsTableView)
//        mainStackView.addArrangedSubview(snacksTableView)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            
//            seatsTableView.heightAnchor.constraint(equalToConstant: 150),
//            snacksTableView.heightAnchor.constraint(equalToConstant: 150),
//        ])
//    }
//    
//    
//    private func setupTableView() {
//        seatsTableView.dataSource = self
//        seatsTableView.delegate = self
//        snacksTableView.dataSource = self
//        snacksTableView.delegate = self
//    }
//    
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        if tableView == seatsTableView {
////            return viewModel.selectedSeats.count
////        } else if tableView == snacksTableView {
////            return viewModel.selectedFood.count
////        }
////        return 0
////    }
////    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == seatsTableView {
//            return viewModel.selectedSeats.count
//        } else if tableView == snacksTableView {
//            var totalRows = 0
//            for food in viewModel.selectedFood {
//                for size in food.sizes {
//                    let quantity = FoodManager.shared.quantity(for: food, size: size)
//                    totalRows += quantity
//                }
//            }
//            return totalRows
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == seatsTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SeatTableViewCell", for: indexPath) as? SeatTableViewCell ?? SeatTableViewCell(style: .default, reuseIdentifier: "SeatTableViewCell")
//            let seat = viewModel.selectedSeats[indexPath.row]
//            
//            if let showTime = viewModel.selectedTimeSlot?.showTime,
//               let ticketPrices = viewModel.selectedTimeSlot?.ticketPrices {
//                cell.configure(with: seat, showTime: showTime, ticketPrices: ticketPrices)
//            } else {
//                cell.configure(with: seat, showTime: .afternoon1, ticketPrices: [])
//            }
//            return cell
//        } else if tableView == snacksTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SnackTableViewCell", for: indexPath) as? SnackTableViewCell ?? SnackTableViewCell(style: .default, reuseIdentifier: "SnackTableViewCell")
//            var currentIndex = indexPath.row
//                    for food in viewModel.selectedFood {
//                        for size in food.sizes {
//                            let quantity = FoodManager.shared.quantity(for: food, size: size)
//                            if quantity > 0 {
//                                if currentIndex == 0 {
//                                    cell.configure(with: food, size: size, quantity: quantity)
//                                    return cell
//                                } else {
//                                    currentIndex -= 1
//                                }
//                            }
//                        }
//                    }
//
//                    return cell 
//            
//        }
//        return UITableViewCell()
//    }
//}
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
    
    private let seatsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SeatTableViewCell.self, forCellReuseIdentifier: "SeatTableViewCell")
        return tableView
    }()
    
    private let snacksTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SnackTableViewCell")
        return tableView
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
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(seatsTableView)
        mainStackView.addArrangedSubview(snacksTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            seatsTableView.heightAnchor.constraint(equalToConstant: 150),
            snacksTableView.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
    
    private func setupTableView() {
        seatsTableView.dataSource = self
        seatsTableView.delegate = self
        snacksTableView.dataSource = self
        snacksTableView.delegate = self
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
