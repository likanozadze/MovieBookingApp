//
//  MovieShowtimeCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/22/24.
//

import UIKit

class MovieShowtimeCell: UITableViewCell {
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ageRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .orange
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
      //  selectionStyle = .none
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.addSubview(timeLabel)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(hallLabel)
        contentView.addSubview(ageRatingLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            posterImageView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.widthAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            
            hallLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 16),
            hallLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            
            ageRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ageRatingLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            ageRatingLabel.widthAnchor.constraint(equalToConstant: 40),
            ageRatingLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func configureAppearance() {
        layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 12
        
        contentView.layer.cornerRadius = layer.cornerRadius
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    func configure(with movieShowtime: MovieShowtime) {
        timeLabel.text = movieShowtime.time
        titleLabel.text = movieShowtime.movie.title
        let genreNames = movieShowtime.movie.genreIds.compactMap { genreId in
            GenreName(rawValue: genreId)?.description
        }.joined(separator: ", ")
        genreLabel.text = genreNames
        priceLabel.text = "Price: \(movieShowtime.price) USD"
        hallLabel.text = "Hall: \(movieShowtime.hall)"
        ageRatingLabel.text = "+\(movieShowtime.ageRating)"
        
        if let posterPath = movieShowtime.movie.posterPath {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let fullPosterURL = baseURL + posterPath
            if let posterURL = URL(string: fullPosterURL) {
                URLSession.shared.dataTask(with: posterURL) { [weak self] data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.posterImageView.image = image
                        }
                    } else if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }.resume()
            }
        } else {
            posterImageView.image = UIImage(named: "placeholder_poster")
        }
    }
}
