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
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        button.setTitle(nil, for: .normal)
        resetButtonTitleColor()
    }
    
    // MARK: - Private Methods
    private func addSubview() {
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
    func configure(for date: Date) {
        let components = calendar.dateComponents([.weekday, .day], from: date)
        guard let weekday = components.weekday, let day = components.day else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let shortWeekday = dateFormatter.string(from: date)
        
        let title = "\(day)\n\(shortWeekday)"
        button.setTitle(title, for: .normal)
    }
    
    
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        toggleButtonTitleColor()
    }
    
    private func toggleButtonTitleColor() {
        let newColor: UIColor = (button.titleColor(for: .normal) == .white) ? .customAccentColor : .white
        button.setTitleColor(newColor, for: .normal)
    }
    
    private func resetButtonTitleColor() {
        button.setTitleColor(.white, for: .normal)
    }
}

