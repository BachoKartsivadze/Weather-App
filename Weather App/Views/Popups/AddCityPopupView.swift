//
//  AddCityPopupView.swift
//  Weather App
//
//  Created by bacho kartsivadze on 26.01.23.
//

import UIKit

class AddCityPopupView: UIView {
    
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Add City"
        label.textColor = .white
        label.font = label.font.withSize(Constants.shared.addCityPopupViewHeaderLabelFontSize)
        return label
    }()
    
    let secondaryHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter City name you wish to add"
        label.textColor = .white
        label.font = label.font.withSize(Constants.shared.addCityPopupViewSecondaryHeaderLabelFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    let textfield: UITextField = {
        let field = UITextField()
        field.placeholder = "City"
        field.backgroundColor = .white
        field.textColor = .black
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let addLocationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill")
        button.setBackgroundImage(image, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowRadius = Constants.shared.shadowRadius
        button.layer.shadowOpacity = Constants.shared.shadowOpacity
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .vertical
        stack.backgroundColor = .systemGreen
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
     let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.isHidden = true
        return view
    }()
    
    
    private let constants = Constants.shared
    
    //--------------------------------------------------------------

    override init(frame: CGRect) {
        super.init(frame: CGRect())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        handleConstraints()
        
        spinner.frame = addLocationButton.bounds
        clipsToBounds = true
        layer.cornerRadius = constants.cornerRadius
        
    }
    
    
    private func setupView() {
        backgroundColor = .systemGreen
        addSubview(stackView)
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(secondaryHeaderLabel)
        stackView.addArrangedSubview(textfield)
        stackView.addArrangedSubview(addLocationButton)
        addLocationButton.addSubview(spinner)
        addLocationButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
    }
    
    @objc private func hideKeyboard() {
        textfield.resignFirstResponder()
    }
    
    
    private func handleConstraints() {
        NSLayoutConstraint.activate([
            addLocationButton.widthAnchor.constraint(equalToConstant: constants.addCityPopupAddLocationButtonWidth),
            addLocationButton.heightAnchor.constraint(equalToConstant: constants.addCityPopupAddLocationButtonHeight),
            
            textfield.widthAnchor.constraint(equalToConstant: frame.width/2),
            textfield.heightAnchor.constraint(equalToConstant: constants.addCityPopupTextFieldHeught),
            
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalToConstant: frame.height - constants.addCityPopupStackViewTopPadding),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
