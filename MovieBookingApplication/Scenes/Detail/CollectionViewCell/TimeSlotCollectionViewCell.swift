//
//  TimeSlotCollectionViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/13/24.


import UIKit

protocol TimeSlotCollectionViewCellDelegate: AnyObject {
    func timeSlotCellTapped(_ cell: TimeSlotCollectionViewCell)
}

final class TimeSlotCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: TimeSlotCollectionViewCellDelegate?
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        priceLabel.text = nil
        isSelected = false
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
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cellView.addGestureRecognizer(tapGesture)
        cellView.isUserInteractionEnabled = true
    }
    
    // MARK: - Configuration
    func configure(with timeSlot: MockTimeSlot, isSelected: Bool) {
        let formattedTime = timeSlot.time
        let priceString = String(format: "$%.2f", timeSlot.price)
        
        timeLabel.text = formattedTime
        priceLabel.text = priceString
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.2) {
            self.cellView.backgroundColor = self.isSelected ? .customAccentColor : .black
            self.cellView.transform = self.isSelected ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }
    }
    
    // MARK: - Actions
    @objc private func cellTapped() {
        isSelected.toggle()
        delegate?.timeSlotCellTapped(self)
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        UIView.animate(withDuration: 0.1, animations: {
            self.cellView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.cellView.transform = self.isSelected ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
        }
    }
}
