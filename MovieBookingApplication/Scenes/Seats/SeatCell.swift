//
//  SeatCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/16/24.
//

import UIKit

final class SeatCell: UICollectionViewCell {
    
    private let seatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var seat: Seat = Seat(0, 0)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(seatImageView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
          
                seatImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                seatImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                seatImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                seatImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        
        ])
    }
    
    // MARK: - Configuration
     func configure(withSeat seat: Seat) {
        self.seat = seat 
        
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        
        if seat.sold {
            seatImageView.image = UIImage(systemName: "xmark.circle", withConfiguration: configuration)
            seatImageView.tintColor = .red
            isUserInteractionEnabled = false
        } else {
            if seat.selected {
                seatImageView.image = UIImage(systemName: "chair.lounge.fill", withConfiguration: configuration)
                seatImageView.tintColor = .customAccentColor
            } else {
                seatImageView.image = UIImage(systemName: "chair.lounge", withConfiguration: configuration)
                seatImageView.tintColor = .customAccentColor
            }
            isUserInteractionEnabled = true
            
        }
    }
}
