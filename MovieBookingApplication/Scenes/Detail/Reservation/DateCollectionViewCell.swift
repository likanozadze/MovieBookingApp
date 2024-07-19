//
//  DateCollectionViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

protocol DateCollectionViewCellDelegate: AnyObject {
    func dateButtonTapped(date: Date)
}

final class DateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let calendar = Calendar.current
    weak var delegate: DateCollectionViewCellDelegate?
    private var date: Date?
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
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
        isSelected = false
        dateLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(cellView)
        cellView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -4),
            dateLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cellView.addGestureRecognizer(tapGesture)
        cellView.isUserInteractionEnabled = true
    }
    
    // MARK: - Configuration
    func configure(for date: Date, isSelected: Bool = false) {
        self.date = date
        let day = DateManager.shared.dayOfMonth(from: date)
        let shortWeekdayString = DateManager.shared.shortWeekday(from: date)
        let title = "\(day)\n\(shortWeekdayString)"
        dateLabel.text = title
        self.isSelected = isSelected
        updateAppearance()
    }
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.2) {
           self.cellView.backgroundColor = self.isSelected ? .black : .black
            self.cellView.transform = self.isSelected ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            self.dateLabel.textColor = self.isSelected ? .customAccentColor : .white
            self.cellView.layer.borderColor = self.isSelected ? UIColor.customAccentColor.cgColor : UIColor.clear.cgColor
            
        }
    }
    
    // MARK: - Actions
    @objc private func cellTapped() {
        isSelected.toggle()
        if let date = self.date {
            delegate?.dateButtonTapped(date: date)
        }
        
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
