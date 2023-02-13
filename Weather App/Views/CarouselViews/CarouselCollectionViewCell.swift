//
//  CarouselCollectionViewCell.swift
//  Weather App
//
//  Created by bacho kartsivadze on 23.01.23.
//

import UIKit
import SDWebImage

class CarouselCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CarouselCollectionViewCell"
    
    private var currentWeather: CurrentWeather = CurrentWeather()
    
    
    private let weatherIconImigeView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.shared.cellLocationLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.shared.cellTemperatureLabelFontSize)
        label.textColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cloudinessBottomView: CarouselCollectionViewCellBottomReusableView = {
        let view = CarouselCollectionViewCellBottomReusableView()
        return view
    }()
    
    private let humidityBottomView: CarouselCollectionViewCellBottomReusableView = {
        let view = CarouselCollectionViewCellBottomReusableView()
        return view
    }()
    
    private let windSpeedBottomView: CarouselCollectionViewCellBottomReusableView = {
        let view = CarouselCollectionViewCellBottomReusableView()
        return view
    }()
    
    private let pressureBottomView: CarouselCollectionViewCellBottomReusableView = {
        let view = CarouselCollectionViewCellBottomReusableView()
        return view
    }()
    
    
    // add stack views
    let topStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let mainsStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let constants = Constants.shared
    
    //--------------------------------------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
        
    }
    
    private func setupCell() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = constants.cornerRadius
        
        addViwesToStacks()
        addConstraints()
        
    }
    
    private func addWeatherInformation() {
        locationLabel.text = (currentWeather.name ?? "error") + ", " + (currentWeather.sys.country ?? "")
        temperatureLabel.text = "\(Int(currentWeather.main.temp ?? 0))°C | \(currentWeather.weather[0].main ?? "error")"
        cloudinessBottomView.configure(with: CarouselCollectionViewCellBottomReusableViewViewModel(
            systemImageName: "cloud.fog",
            infoText: "Cloudiness",
            valueText: "\(currentWeather.clouds.all ?? 0) %"
        ))
        humidityBottomView.configure(with: CarouselCollectionViewCellBottomReusableViewViewModel(
            systemImageName: "humidity",
            infoText: "Humidity",
            valueText: "\(currentWeather.main.humidity ?? 0) mm"
        ))
        windSpeedBottomView.configure(with: CarouselCollectionViewCellBottomReusableViewViewModel(
            systemImageName: "wind",
            infoText: "Wind Speed",
            valueText: "\(currentWeather.wind.speed ?? 0) km/h"
        ))
        pressureBottomView.configure(with: CarouselCollectionViewCellBottomReusableViewViewModel(
            systemImageName: "digitalcrown.horizontal.press",
            infoText: "Pressure",
            valueText: "\(currentWeather.main.pressure ?? 0) pas"
        ))
        
        // load image
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(currentWeather.weather[0].icon ?? "01d").png") else { return }
        weatherIconImigeView.sd_setImage(with: url, completed: nil)
    }
    
    func transformToLarge() {
        UIView.animate(withDuration: constants.cellGetLargerDuration) {
            self.transform = CGAffineTransform(scaleX: 1, y: self.constants.cellGetLargerMultiplier)
        }
    }
    
    func transformToStandart() {
        UIView.animate(withDuration: constants.cellGetLargerDuration) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    public func configure(with model: CurrentWeather){
        self.currentWeather = model
        DispatchQueue.main.async { [weak self] in
            self?.addWeatherInformation()
        }
    }
    
    private func addViwesToStacks() {
        contentView.addSubview(mainsStack)
        
        mainsStack.addArrangedSubview(topStack)
        mainsStack.addArrangedSubview(bottomStack)
        
        let bottomSpaceView = UIView()
        bottomSpaceView.translatesAutoresizingMaskIntoConstraints = false
        bottomSpaceView.heightAnchor.constraint(equalToConstant: constants.bottomSpaceViewHeight).isActive = true
        bottomSpaceView.widthAnchor.constraint(equalToConstant: constants.bottomSpaceViewWidth).isActive = true
        
        topStack.addArrangedSubview(weatherIconImigeView)
        topStack.addArrangedSubview(locationLabel)
        topStack.addArrangedSubview(temperatureLabel)
        topStack.addArrangedSubview(bottomSpaceView) // clear view for spaceing
        
        bottomStack.addArrangedSubview(UIView()) // clear view for spaceing
        bottomStack.addArrangedSubview(cloudinessBottomView)
        bottomStack.addArrangedSubview(humidityBottomView)
        bottomStack.addArrangedSubview(windSpeedBottomView)
        bottomStack.addArrangedSubview(pressureBottomView)
        bottomStack.addArrangedSubview(UIView()) // clear view for spaceing
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        let topColor = constants.gradientTopColor.cgColor
        let bottomColor = constants.gradientBottomColor.cgColor
        gradient.colors = [topColor, bottomColor]
        contentView.layer.insertSublayer(gradient, at: 0)
    }
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainsStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            weatherIconImigeView.heightAnchor.constraint(equalTo: topStack.heightAnchor, multiplier: constants.weatherIconHeightMultiplier),
            weatherIconImigeView.widthAnchor.constraint(equalTo: topStack.widthAnchor, multiplier: constants.weatherIconWidthMultiplier)
            
        ])
    }
}
