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
        view.layer.masksToBounds = true
        return view
    }()

    private let dateButton: ReusableButton = {
           let button = ReusableButton(title: "", hasBackground: true, fontSize: .small)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        resetButtonTitleColor()
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(cellView)
        cellView.addSubview(dateButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 60),
            
            dateButton.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            dateButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            dateButton.topAnchor.constraint(equalTo: cellView.topAnchor),
            dateButton.bottomAnchor.constraint(equalTo: cellView.bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    private func configureButton() {
        dateButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        dateButton.titleLabel?.numberOfLines = 0
        
    }
    
    func configure(for date: Date) {
        self.date = date
        let day = DateManager.shared.dayOfMonth(from: date)
        let shortWeekdayString = DateManager.shared.shortWeekday(from: date)
        let title = "\(day)\n\(shortWeekdayString)"
        dateButton.setTitle(title, for: .normal)
    }
    
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        toggleButtonTitleColor()
        if let date = self.date {
            delegate?.dateButtonTapped(date: date)
        }
    }
    
    private func toggleButtonTitleColor() {
        let newColor: UIColor = (dateButton.titleColor(for: .normal) == .white) ? .customAccentColor : .white
        dateButton.setTitleColor(newColor, for: .normal)
    }
    
    private func resetButtonTitleColor() {
        dateButton.setTitleColor(.white, for: .normal)
    }
}
