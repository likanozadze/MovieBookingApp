//
//  NowInCinemasCollectionViewCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class NowInCinemasCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private lazy var titleGenreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, genreLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let voteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var voteLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [voteLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.customAccentColor
        stackView.layer.cornerRadius = 4
        stackView.layer.masksToBounds = false
        return stackView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
        setupCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        movieImageView.image = nil
        genreLabel.text = nil
        titleLabel.text = nil
        voteLabel.text = nil
        
    }
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(movieImageView)
        contentView.addSubview(voteLabelStackView)
        contentView.addSubview(titleGenreStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 220),
            
            voteLabelStackView.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 10),
            voteLabelStackView.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 10),
            voteLabelStackView.widthAnchor.constraint(equalToConstant: 25),
            voteLabelStackView.heightAnchor.constraint(equalToConstant: 20),
            
            titleGenreStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 12),
            titleGenreStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleGenreStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
        ])
    }
    
    
    private func setupCellAppearance() {
        layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 12
        
        contentView.layer.cornerRadius = layer.cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    // MARK: - Configuration
    func configure(with movie: MockMovie) {
      //  print("Configuring cell for movie: \(movie.title)")
        titleLabel.text = movie.title
        
        let genreNames = movie.genres.map { $0.description }.joined(separator: ", ")
        genreLabel.text = genreNames
        
        voteLabel.text = String(format: "%.1f", movie.voteAverage)
        if let posterPath = movie.posterPath {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let fullPosterURL = baseURL + posterPath
            if let posterURL = URL(string: fullPosterURL) {
                URLSession.shared.dataTask(with: posterURL) { [weak self] data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.movieImageView.image = image
                        }
                    } else if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }.resume()
            }
        } else {
            movieImageView.image = UIImage(named: "placeholder_poster")
        }
    }
}
