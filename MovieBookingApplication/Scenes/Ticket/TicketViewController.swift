//
//  TicketViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/26/24.
//

import UIKit
import Lottie

final class TicketViewController: UIViewController {
    
    // MARK: - Properties
    private let bookingManager = BookingManager.shared
    
    private let viewModel = TicketViewModel()
    
    private let animationView = LottieAnimationView()
    
    let emptyStateViewController = EmptyStateViewController(
        title: "Your tickets will appear here", description: "You haven't booked any movies yet", animationName: "Tickets")
    
    private let ticketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 500)
        layout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        BookingManager.shared.ticketViewController = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadTickets()
        updateViewState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.stop()
    }
    // MARK: - Private Methods
    private func setup() {
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupCollectionView()
        
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
        
    }
    private func setupSubviews(){
        view.addSubview(ticketCollectionView)
        view.addSubview(animationView)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ticketCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ticketCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ticketCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ticketCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        ticketCollectionView.dataSource = self
        ticketCollectionView.delegate = self
        ticketCollectionView.register(TicketCollectionViewCell.self, forCellWithReuseIdentifier: "TicketCell")
    }
    
    
    func updateViewState() {
        viewModel.loadTickets()
        if viewModel.hasTickets {
            hideEmptyState()
            ticketCollectionView.reloadData()
            ticketCollectionView.isHidden = false
        } else {
            showEmptyState()
            ticketCollectionView.isHidden = true
        }
        updateBadge()
    }
    
    private func hasTickets() -> Bool {
        return BookingManager.shared.numberOfTickets > 0
    }
    
    private func showEmptyState() {
        if children.contains(emptyStateViewController) { return }
        
        addChild(emptyStateViewController)
        view.addSubview(emptyStateViewController.view)
        emptyStateViewController.view.frame = view.bounds
        emptyStateViewController.didMove(toParent: self)
        
    }
    
    private func hideEmptyState() {
        if children.contains(emptyStateViewController) {
            emptyStateViewController.willMove(toParent: nil)
            emptyStateViewController.view.removeFromSuperview()
            emptyStateViewController.removeFromParent()
        }
    }
    
    func updateBadge() {
        let ticketCount = viewModel.ticketCount
        self.tabBarItem.badgeValue = ticketCount > 0 ? "\(ticketCount)" : nil
    }
}
extension TicketViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tickets.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCell", for: indexPath) as? TicketCollectionViewCell else {
            fatalError("Unable to dequeue TicketCollectionViewCell")
        }
        
        let ticket = viewModel.tickets[indexPath.item]
        print("Configuring cell for ticket: \(ticket.movieTitle ?? "Unknown"), Poster Path: \(ticket.posterPath ?? "None")")
        cell.configure(with: ticket)
        return cell
    }
}
