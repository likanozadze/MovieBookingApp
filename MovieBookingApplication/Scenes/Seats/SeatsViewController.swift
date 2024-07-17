//
//  SeatsViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/16/24.
//



import UIKit

final class SeatsViewController: UIViewController {

// MARK: - Properties
private var collectionView: UICollectionView = {
let layout = UICollectionViewFlowLayout()
let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
collectionView.backgroundColor = .clear
collectionView.showsHorizontalScrollIndicator = false
return collectionView
}()

private let seatManager = SeatManager.shared
private let rowsPerSection = [6, 6, 6, 6, 6, 6, 4, 4, 4]

// MARK: - ViewLifeCycles

override func viewDidLoad() {
super.viewDidLoad()
setup()
setupCollectionView()
initializeSeats()
}

private func setup() {
setupBackground()
setupSubviews()
setupConstraints()
}

private func setupBackground() {
view.backgroundColor = .customBackgroundColor
}

private func setupCollectionView() {
collectionView.register(SeatCell.self, forCellWithReuseIdentifier: "seatCell")
collectionView.dataSource = self
collectionView.delegate = self
}
    
private func setupSubviews() {
    
    view.addSubview(collectionView)
}

private func setupConstraints() {
collectionView.translatesAutoresizingMaskIntoConstraints = false

NSLayoutConstraint.activate([
collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
])
}

func initializeSeats() {
let numberOfSections = rowsPerSection.count
seatManager.setSeats(for: numberOfSections, rowsPerSection: rowsPerSection)
}
}

// MARK: - UICollectionViewDataSource

extension SeatsViewController: UICollectionViewDataSource {

func numberOfSections(in collectionView: UICollectionView) -> Int {
    return rowsPerSection.count
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return rowsPerSection[section]
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seatCell", for: indexPath) as? SeatCell else {
    fatalError("Could not dequeue seat cell")
}
guard let seat = seatManager.getSeat(by: indexPath.section, row: indexPath.row) else {
    print("Seat not found at indexPath: \(indexPath)")
    return cell
}
cell.configure(withSeat: seat)
return cell
}
}

// MARK: - UICollectionViewDelegate

extension SeatsViewController: UICollectionViewDelegate {

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
guard let seat = seatManager.getSeat(by: indexPath.section, row: indexPath.row) else { return }
    if !seat.sold {
        seatManager.selectSeat(seat)
        collectionView.reloadItems(at: [indexPath])
    }

}
}
