//
//  MainViewController.swift
//  Weather App
//
//  Created by bacho kartsivadze on 19.01.23.
//

import UIKit

class MainViewController: UITabBarController {
    
    private let constants = Constants.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let vc1 = UINavigationController(rootViewController: TodayViewController())
        let vc2 = UINavigationController(rootViewController: ForecastViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "sun.max")
        vc2.tabBarItem.image = UIImage(systemName: "clock")
        
        view.tintColor = .yellow
        addGradient()
        
        UITabBar.appearance().unselectedItemTintColor = .white
        
        vc1.title = "Today"
        vc2.title = "Forecast"
        
        setViewControllers([vc1,vc2], animated: true)
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let topColor = constants.gradientTopColor.cgColor
        let bottomColor = constants.gradientBottomColor.cgColor
        gradient.colors = [topColor, bottomColor]
        view.layer.insertSublayer(gradient, at: 0)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.layer.sublayers?[0].frame = view.bounds
    }

}

