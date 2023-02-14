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
        let windDirection = calculateWindDirection(deg: currentWeather.wind.deg ?? 361)
        
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
            systemImageName: "arrow.left.arrow.right",
            infoText: "Wind Direction",
            valueText: "\(windDirection)"
        ))
        
        // load image
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(currentWeather.weather[0].icon ?? "01d").png") else { return }
        weatherIconImigeView.sd_setImage(with: url, completed: nil)
    }
    
    private func calculateWindDirection(deg: Int) -> String {
        switch deg {
        case 11...34: return "NNE"
        case 34...56: return "NE"
        case 56...78: return "ENE"
        case 78...101: return "E"
        case 101...124: return "ESE"
        case 124...146: return "SE"
        case 146...169: return "SSE"
        case 169...191: return "S"
        case 191...214: return "SSW"
        case 214...236: return "SW"
        case 236...259: return "WSW"
        case 259...281: return "W"
        case 282...304: return "WNW"
        case 304...326: return "NW"
        case 326...349: return "NNW"
        case 0...11, 349...360: return "N"
        default:
            return "error"
        }
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
