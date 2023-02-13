//
//  NotificationView.swift
//  Weather App
//
//  Created by bacho kartsivadze on 01.02.23.
//

import UIKit

class NotificationView: UIView {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Error Occured"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constants.shared.notificationViewHeaderlabelFontSize, weight: .regular)
        
        return label
    }()
    
    let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Unknown"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constants.shared.notificationViewSecondarylabelFontSize, weight: .regular)
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        layer.cornerRadius = constants.cornerRadius
    }
    
    private func setupView() {
        backgroundColor = .red
        addSubview(stackView)
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(secondaryLabel)
        
    }
    
    public func configure(headerText: String, secondaryText: String, backGroundColor: UIColor) {
        headerLabel.text = headerText
        secondaryLabel.text = secondaryText
        self.backgroundColor = backGroundColor
    }

}
