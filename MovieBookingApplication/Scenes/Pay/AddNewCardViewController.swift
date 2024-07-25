//
//  AddNewCardViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import UIKit

final class AddNewCardViewController: UIViewController {
    // MARK: - Properties
 
    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Add payment card"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "Name on card", keyboardType: .alphabet, icon: UIImage(systemName: "person"))
        textField.tag = TextFieldType.name.rawValue
        return textField
    }()
    
    private let cardNumberTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "0000 0000 0000 0000", keyboardType: .numberPad, icon: UIImage(systemName: "creditcard"))
        textField.tag = TextFieldType.cardNumber.rawValue
        return textField
    }()
    
    private lazy var dateAndCvcStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [expiryDateTextField, cvcTextField])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private let expiryDateTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "MM/YY", keyboardType: .numberPad, icon: UIImage(systemName: "calendar"))
        textField.tag = TextFieldType.expiryDate.rawValue
        return textField
    }()
    
    private let cvcTextField: UITextField = {
        let textField = CustomTextField()
        textField.configure(placeholder: "CVC", keyboardType: .numberPad, icon: UIImage(systemName: "creditcard.and.123"))
        textField.tag = TextFieldType.cvc.rawValue
        return textField
    }()
    
    private let addCardButton: ReusableButton = {
        let button = ReusableButton(title: "Add card", hasBackground: false, fontSize: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        setupTextFieldDelegates()
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupTapGestureRecogniser()
        updateAddCardButtonState()
    }
    
    private func setupTextFieldDelegates() {
        [nameTextField, cardNumberTextField, expiryDateTextField, cvcTextField].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    private func allFieldsAreValid() -> Bool {
        let nameIsValid = nameTextField.text?.contains(" ") ?? false && !nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let cardNumberIsValid = cardNumberTextField.text?.isEmpty == false && cardNumberTextField.text?.replacingOccurrences(of: " ", with: "").count == 16
        let expiryDateIsValid = expiryDateTextField.text?.isEmpty == false && expiryDateTextField.text?.replacingOccurrences(of: "/", with: "").count == 4
        let cvcIsValid = cvcTextField.text?.isEmpty == false &&
        cvcTextField.text!.count == 3
        
        return nameIsValid && cardNumberIsValid && expiryDateIsValid && cvcIsValid
    }
    
    private func setupBackground() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(headerLabel)
        mainStackView.addArrangedSubview(nameTextField)
        mainStackView.addArrangedSubview(cardNumberTextField)
        mainStackView.addArrangedSubview(dateAndCvcStackView)
        mainStackView.addArrangedSubview(addCardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
                            cardNumberTextField.heightAnchor.constraint(equalToConstant: 48),
                            expiryDateTextField.heightAnchor.constraint(equalToConstant: 48),
                            cvcTextField.heightAnchor.constraint(equalToConstant: 48),
            addCardButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTapGestureRecogniser() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEndEditing))
        view.addGestureRecognizer(tap)
    }

    
    private func updateAddCardButtonState() {
        addCardButton.isEnabled = allFieldsAreValid()
        addCardButton.alpha = allFieldsAreValid() ? 1.0 : 0.5
    }
    
    @objc private func handleEndEditing() {
        view.endEditing(true)
    }

    
    @objc private func textFieldDidChange() {
        updateAddCardButtonState()
    }
}

// MARK: - TextFieldTypes
enum TextFieldType: Int {
    case name = 0
    case cardNumber
    case expiryDate
    case cvc
}

// MARK: - Extension: TextField Validations
extension AddNewCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch TextFieldType(rawValue: textField.tag) {
        case .name:
            let allowedCharacters = CharacterSet.letters.union(.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
            
        case .cardNumber:
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let numericText = replacementText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let maxLength = 16
            if numericText.count > maxLength { return false }
            var formattedText = ""
            for (index, character) in numericText.enumerated() {
                if index % 4 == 0 && index > 0 { formattedText += " " }
                formattedText.append(character)
            }
            textField.text = formattedText
            return false
            
        case .expiryDate:
            let fullText = (textField.text ?? "") as NSString
            let updatedText = fullText.replacingCharacters(in: range, with: string)
            guard string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil, updatedText.count <= 5 else { return false }
            var newText = updatedText.replacingOccurrences(of: "/", with: "")
            if newText.count > 2 { newText = String(newText.prefix(2)) + "/" + newText.dropFirst(2) }
            if newText.count >= 5 {
                let yearString = String(newText.suffix(2))
                let currentYear = Calendar.current.component(.year, from: Date()) % 100
                if let year = Int(yearString), year < currentYear { return false }
            }
            if newText.count >= 2 {
                let monthString = String(newText.prefix(2))
                if let month = Int(monthString), month < 1 || month > 12 { return false }
            }
            textField.text = newText
            return false
            
        case .cvc:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let maxLength = 3
            let currentText = textField.text ?? ""
            return allowedCharacters.isSuperset(of: characterSet) && currentText.count + string.count <= maxLength
            
        case .none:
            return true
        }
    }
}
