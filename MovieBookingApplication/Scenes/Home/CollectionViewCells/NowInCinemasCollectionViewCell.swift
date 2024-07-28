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
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let firstGenre = movie.genres.first {
            genreLabel.text = firstGenre.name
          } else {
            genreLabel.text = "No Genre"
          }
          
        setImage(from: movie.posterPath)
        let formattedVoteAverage = String(format: "%.1f", movie.voteAverage)
        voteLabel.text = formattedVoteAverage
        
        
    }
    
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.movieImageView.image = image
            }
        }
    }
}
