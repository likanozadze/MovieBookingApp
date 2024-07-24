//
//  FoodItemCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/20/24.


import UIKit

protocol FoodCollectionViewCellDelegate: AnyObject {
    func addProduct(for cell: FoodItemCell?)
    func removeProduct(for cell: FoodItemCell?)
}

final class FoodItemCell: UITableViewCell {
    // MARK: - Properties
    
    weak var delegate: FoodCollectionViewCellDelegate?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productSizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productTitleLabel, productSizeLabel, productPriceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let selectedQuantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
   private let buttonSize: CGFloat = 30
    
    private let subtractButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .customSecondaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .customSecondaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var selectProductStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subtractButton, selectedQuantityLabel, addButton])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private lazy var snackStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoStackView, selectProductStackView])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var viewModel: FoodViewModel?
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
        configureAppearance()
        addActions()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        foodImageView.image = nil
        productTitleLabel.text = nil
        productSizeLabel.text = nil
        productPriceLabel.text = nil
        selectedQuantityLabel.text = nil
    }
    
    // MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(foodImageView)
        mainStackView.addArrangedSubview(snackStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            foodImageView.widthAnchor.constraint(equalToConstant: 80),
            foodImageView.heightAnchor.constraint(equalToConstant: 80),
          
        ])
    }
    
    private func configureAppearance() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        subtractButton.layer.cornerRadius = buttonSize / 2
        addButton.layer.cornerRadius = buttonSize / 2

        productTitleLabel.numberOfLines = 0
        productSizeLabel.numberOfLines = 1
        productPriceLabel.numberOfLines = 1
    }
    
    // MARK: - Configuration
    
    func configure(with food: Food, size: FoodSize, quantity: Int) {
        foodImageView.image = UIImage(named: food.imageName)
        productTitleLabel.text = food.name
        productSizeLabel.text = size.name
        productPriceLabel.text = "$\(food.price + size.priceModifier)"
        
        selectedQuantityLabel.text = "\(quantity)"
    }
    
    
    private func addActions() {
        addButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            self?.delegate?.addProduct(for: self)
        }), for: .touchUpInside)
        
        subtractButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            self?.delegate?.removeProduct(for: self)
        }), for: .touchUpInside)
    }
}
