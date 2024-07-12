//
//  DateCollectionViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//


import UIKit

final class DateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let calendar = Calendar.current
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, weekdayLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        weekdayLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func  addSubview() {
        contentView.addSubview(cellView)
        cellView.addSubview(dateStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 60),
            dateStackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            dateStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            dateStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            dateStackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Configuration
    func configure(for date: Date) {
        let components = calendar.dateComponents([.weekday, .day], from: date)
        guard let weekday = components.weekday, let day = components.day else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let shortWeekday = dateFormatter.string(from: date)
        
        weekdayLabel.text = "\(shortWeekday)"
        dateLabel.text = "\(day)"
    }
    
}
