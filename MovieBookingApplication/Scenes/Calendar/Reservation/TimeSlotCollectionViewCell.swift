//
//  TimeSlotCollectionViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/13/24.
//

import UIKit

class TimeSlotCollectionViewCell: UICollectionViewCell {

  // MARK: - Properties
  private let cellView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()

  private let button: ReusableButton = {
    let button = ReusableButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews()
    setupConstraints()
    configureButton()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Cell Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    button.setTitle(nil, for: .normal)
  }

  // MARK: - Private Methods
  private func addSubviews() {
    contentView.addSubview(cellView)
    cellView.addSubview(button)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
      cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
      cellView.centerYAnchor.constraint(equalTo: centerYAnchor),
      cellView.heightAnchor.constraint(equalToConstant: 60),

      button.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
      button.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
      button.topAnchor.constraint(equalTo: cellView.topAnchor),
      button.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
    ])
  }

  // MARK: - Configuration
  func configure(time: String, price: String) {
      let attributedString = NSMutableAttributedString(string: "\(time)\n\(price)")
          attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: NSRange(location: 0, length: time.count))
          attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .regular)], range: NSRange(location: time.count + 1, length: price.count))

      button.setTitle(nil, for: .normal)
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.numberOfLines = 0
  }

  private func configureButton() {
    button.setStyle(.secondary)
  }
}
