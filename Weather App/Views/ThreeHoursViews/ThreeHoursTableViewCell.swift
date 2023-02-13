//
//  ThreeHoursTableViewCell.swift
//  Weather App
//
//  Created by bacho kartsivadze on 03.02.23.
//

import UIKit

class ThreeHoursTableViewCell: UITableViewCell {
    
    static let identifier = "ThreeHoursTableViewCell"
    
    private let weatherIconImigeView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.shared.tableViewCellTimeLabelFontSize)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.shared.tableViewCellDescriptionLabelFontSize)
        label.textColor = .white
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(Constants.shared.tableViewCellTemperatureLabelFontSize)
        label.textColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeAndDescriptionStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let constants = Constants.shared
    
    //--------------------------------------------------------------

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(weatherIconImigeView)
        contentView.addSubview(timeAndDescriptionStack)
        contentView.addSubview(temperatureLabel)
        timeAndDescriptionStack.addArrangedSubview(timeLabel)
        timeAndDescriptionStack.addArrangedSubview(descriptionLabel)
        activeConstraints()
    }
    
    public func configure(with model: List) {
        // load image
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(model.weather[0].icon ?? "01d").png") else { return }
        weatherIconImigeView.sd_setImage(with: url, completed: nil)

        // load time
        let hour = getHourFromDate(date: model.dt_txt ?? "? ?")
        timeLabel.text = hour

        descriptionLabel.text = model.weather[0].description

        temperatureLabel.text = "\(Int(model.main.temp ?? 0))°C"
    }
    
//    public func configure() {
//        
//        // load image
//        guard let url = URL(string: "http://openweathermap.org/img/wn/10n.png") else { return }
//        weatherIconImigeView.sd_setImage(with: url, completed: nil)
//        
//        // load time
//        timeLabel.text = "01:00"
//        
//        descriptionLabel.text = "light Rain"
//        
//        temperatureLabel.text = "23°C"
//    }
    
    
    private func getHourFromDate(date: String) -> String {
        let dateArr = date.components(separatedBy: [" ", ":"])
        return "\(dateArr[1]):\(dateArr[2])"
    }
    
    private func activeConstraints() {
        NSLayoutConstraint.activate([
            weatherIconImigeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constants.tableViewCellWeatherIconImageViewLeadingPadding),
            weatherIconImigeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImigeView.widthAnchor.constraint(equalToConstant: constants.tableViewCellWeatherIconImageViewWidth),
            weatherIconImigeView.heightAnchor.constraint(equalToConstant: constants.tableViewCellWeatherIconImageViewHeight),
            
            timeAndDescriptionStack.leadingAnchor.constraint(equalTo: weatherIconImigeView.trailingAnchor, constant: constants.tableViewCellTimeAndDescriptionStackLeadingPadding),
            timeAndDescriptionStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeAndDescriptionStack.widthAnchor.constraint(equalToConstant: constants.tableViewCellTimeAndDescriptionStackWidth),
            timeAndDescriptionStack.heightAnchor.constraint(equalToConstant: constants.tableViewCellTimeAndDescriptionStackHeight),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: constants.tableViewCellTemperatureLabelTrailingPadding),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
}
