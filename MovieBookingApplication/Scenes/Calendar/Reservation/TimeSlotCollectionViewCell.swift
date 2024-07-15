//
//  TimeSlotCollectionViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/13/24.
//

import UIKit

final class TimeSlotCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Properties
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private var isColored = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cellView.addGestureRecognizer(tapGesture)
        cellView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        priceLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(cellView)
        cellView.addSubview(timeLabel)
        cellView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 80),
            
            timeLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: cellView.topAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            priceLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(time: String, price: String) {
        timeLabel.text = time
        priceLabel.text = price
    }
    
    @objc private func cellTapped() {
          if isColored {
              cellView.backgroundColor = .black
          } else {
              cellView.backgroundColor = .customButtonBackgroundColor
          }
          isColored.toggle()
      }
  }
