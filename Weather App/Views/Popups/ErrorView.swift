//
//  ErrorView.swift
//  Weather App
//
//  Created by bacho kartsivadze on 27.01.23.
//

import UIKit

class ErrorView: UIView {
    
    private let errorImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "sun.max.trianglebadge.exclamationmark")
        view.tintColor = .systemOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Error occured while loading data"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constants.shared.errorViewHeaderLabelFontSize, weight: .semibold)
        
        return label
    }()
    
    let reloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reload", for: .normal)
        button.backgroundColor = .systemOrange
        button.tintColor = .white
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowRadius = Constants.shared.shadowRadius
        button.layer.shadowOpacity = Constants.shared.shadowOpacity
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        return stack
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
    
    
    private func setupView() {
        addSubview(stackView)
        stackView.frame = bounds
        stackView.addArrangedSubview(errorImage)
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(reloadButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            errorImage.widthAnchor.constraint(equalToConstant: constants.errorViewErrorImageWidth),
            errorImage.heightAnchor.constraint(equalToConstant: constants.errorViewErrorImageHeight),
            
            reloadButton.widthAnchor.constraint(equalToConstant: constants.errorViewReloadbuttonWidth),
            reloadButton.heightAnchor.constraint(equalToConstant: constants.errorViewReloadButtonHeight)
        ])
    }
}
