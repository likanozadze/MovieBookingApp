//
//  FoodItemCell.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/20/24.
//
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
        stackView.spacing = 12
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    
    private lazy var selectProductStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [subtractButton, selectedQuantityLabel, addButton])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let selectedQuantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let buttonSize: CGFloat = 10
    
    private let subtractButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .customSecondaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .customSecondaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(productTitleLabel)
        infoStackView.addArrangedSubview(productSizeLabel)
        
        infoStackView.addArrangedSubview(productPriceLabel)
        infoStackView.addArrangedSubview(selectProductStackView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            foodImageView.widthAnchor.constraint(equalToConstant: 120),
            foodImageView.heightAnchor.constraint(equalToConstant: 120),
            
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            selectProductStackView.centerXAnchor.constraint(equalTo: infoStackView.centerXAnchor),
            selectProductStackView.bottomAnchor.constraint(equalTo: infoStackView.bottomAnchor)
        ])
    }
    
    private func configureAppearance() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        subtractButton.layer.cornerRadius = buttonSize / 2
        addButton.layer.cornerRadius = buttonSize / 2

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
