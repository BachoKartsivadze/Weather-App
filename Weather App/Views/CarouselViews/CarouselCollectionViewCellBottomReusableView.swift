//
//  CarouselCollectionViewCellBottomReusableView.swift
//  Weather App
//
//  Created by bacho kartsivadze on 24.01.23.
//

import UIKit

class CarouselCollectionViewCellBottomReusableView: UIView {
    
    static let identifier = "CarouselCollectionViewCellBottomReusableView"
    
    private let weatherImage: UIImageView = {
        let view = UIImageView()
        view.tintColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.font = label.font.withSize(Constants.shared.bottomReusableViewInfoLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.shared.bottomReusableViewValueLabelFontSize)
        label.textColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(weatherImage)
        addSubview(infoLabel)
        addSubview(valueLabel)

        addingConstraints()
    }
    
    public func configure(with model: CarouselCollectionViewCellBottomReusableViewViewModel) {
        weatherImage.image = UIImage(systemName: model.systemImageName)
        infoLabel.text = model.infoText
        valueLabel.text = model.valueText
    }
    
    func addingConstraints() {
        NSLayoutConstraint.activate([
            weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constants.bottomReusableWeatherImageLeadingPadding),
            
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: constants.bottomReusableInfoLabelLeadingPadding),
            
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: constants.bottomReusableValueLabelTrailingPadding)
        ])
    }
}
