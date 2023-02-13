//
//  Constants.swift
//  Weather App
//
//  Created by bacho kartsivadze on 07.02.23.
//

import Foundation
import UIKit

struct Constants {
    
    static let shared = Constants()
    
    private init() {}
    
    let API_KEY = "9ece5e051709ed7383bfc50acb02a565"
    
    
    // MARK: todayViewController
    
    // Portrait
    let collectionViewLayoutWidth: CGFloat = 220
    let collectionViewLayoutHeight:CGFloat = 400
    // Landscape
    let collectionViewLayoutWidthLandscape: CGFloat = 500
    let collectionViewLayoutHeightLandscape:CGFloat = 240
    
    // Portrait
    let collectionViewLeadingPadding: CGFloat = 20
    let collectionViewTrailingPadding: CGFloat = -20
    let collectionViewDeviationFromYAxis: CGFloat = -30
    let collectionViewHeight: CGFloat = 450
    // Landscape
    let collectionViewLeadingPaddingLandscape: CGFloat = 20
    let collectionViewTrailingPaddingLandscape: CGFloat = -20
    let collectionViewDeviationFromYAxisLandscape: CGFloat = -15
    let collectionViewHeightLandscape: CGFloat = 240
    
    // Portrait
    let loctionButtonTopPadding: CGFloat = 20
    let loctionButtonHeight: CGFloat = 65
    let loctionButtonWidth: CGFloat = 65
    // Landscape
    let loctionButtonTopPaddingLandscape: CGFloat = 5
    let loctionButtonHeightLandscape: CGFloat = 50
    let loctionButtonWidthLandscape: CGFloat = 50
    
    // Portrait
    let pageControlBottomPadding: CGFloat = 15
    let pageControlHeight: CGFloat = 60
    // Landscape
    let pageControlBottomPaddingLandscape: CGFloat = 5
    let pageControlHeightLandscape: CGFloat = 30
    
    
    let errorViewWidth: CGFloat = 300
    let errorViewHeight: CGFloat = 200
    
    
    let notificationViewHeight: CGFloat = 70
    let notificationViewWidth: CGFloat = 340
    let notificationViewDeviationFromTop: CGFloat = -70
    
    let notificationAnimationDuration: Double = 4
    let notificationAnimationShowDelay: Double = 0.5
    let notificationAnimationHideDelay: Double = 1
    let notificationScrollLength: CGFloat = 200
    
    
    
    
    let addCityPopupWidth: CGFloat = 300
    let addCityPopupHeight: CGFloat = 250
    
    let navBarFontSize: CGFloat = 18
    
    let shadowRadius: Double = 2.0
    let shadowOpacity: Float = 0.5
    
    let minOffSetToTransform: CGFloat = -20
    let maxOffSetToTransform: CGFloat = 20
    
    let itemSizeLandScape:CGSize = CGSize(width: 500, height: 160)
    let itemSizePortrait:CGSize = CGSize(width: 250, height: 360)
    
    let collectionViewMinimumSpaceing: CGFloat = 25
    
    
    
    
    // MARK: ForecastViewController
    let gradientTopColor: UIColor = UIColor.init(displayP3Red: 0.4, green: 0.65, blue: 0.75, alpha: 0.7)
    let gradientBottomColor: UIColor = UIColor.init(displayP3Red: 0.2, green: 0.45, blue: 0.9, alpha: 0.6)
//    let gradientTopColor: UIColor = UIColor.init(displayP3Red: 0.25, green: 0.55, blue: 0.85, alpha: 0.95)
//    let gradientBottomColor: UIColor = UIColor.init(displayP3Red: 0.1, green: 0.15, blue: 0.4, alpha: 1)
    
    let tableViewHeightForRow: CGFloat = 52
    let tableViewHeightForHeader: CGFloat = 44
    
    
    
    // MARK: CarouselCollectionViewCell
    let cellLocationLabelFontSize: CGFloat = 17
    let cellTemperatureLabelFontSize: CGFloat = 22
    
    let cornerRadius: CGFloat = 20
    
    let cellGetLargerDuration: Double = 0.3
    let cellGetLargerMultiplier: Double = 1.1
    
    let weatherIconHeightMultiplier: Double = 0.6
    let weatherIconWidthMultiplier: Double = 0.8
    
    let bottomSpaceViewWidth: CGFloat = 100
    let bottomSpaceViewHeight: CGFloat = 10
    
    
    // MARK: CarouselCollectionViewCellBottomReusableView
    let bottomReusableViewInfoLabelFontSize: CGFloat = 13
    let bottomReusableViewValueLabelFontSize: CGFloat = 18
    
    let bottomReusableWeatherImageLeadingPadding: CGFloat = 25
    let bottomReusableInfoLabelLeadingPadding: CGFloat = 10
    let bottomReusableValueLabelTrailingPadding: CGFloat = -25
    
    
    // MARK: AddCityPopupView
    let addCityPopupViewHeaderLabelFontSize: CGFloat = 22
    let addCityPopupViewSecondaryHeaderLabelFontSize: CGFloat = 18
    
    let addCityPopupAddLocationButtonWidth: CGFloat = 55
    let addCityPopupAddLocationButtonHeight: CGFloat = 55
    
    let addCityPopupTextFieldHeught: CGFloat = 44
    let addCityPopupStackViewTopPadding: CGFloat = 30
    
    
    // MARK: ErrorView
    let errorViewHeaderLabelFontSize: CGFloat = 18
    
    let errorViewErrorImageWidth: CGFloat = 60
    let errorViewErrorImageHeight: CGFloat = 60
    
    let errorViewReloadbuttonWidth: CGFloat = 110
    let errorViewReloadButtonHeight: CGFloat = 52
    
    
    // MARK: NotificationView
    let notificationViewHeaderlabelFontSize: CGFloat = 20
    let notificationViewSecondarylabelFontSize: CGFloat = 17
    
    
    // MARK: ThreeHoursTableViewCell
    let tableViewCellTimeLabelFontSize: CGFloat = 17
    let tableViewCellDescriptionLabelFontSize: CGFloat = 17
    let tableViewCellTemperatureLabelFontSize: CGFloat = 22
    
    let tableViewCellWeatherIconImageViewLeadingPadding: CGFloat = 20
    let tableViewCellWeatherIconImageViewWidth: CGFloat = 45
    let tableViewCellWeatherIconImageViewHeight: CGFloat = 45
    let tableViewCellTimeAndDescriptionStackLeadingPadding: CGFloat = 20
    let tableViewCellTimeAndDescriptionStackWidth: CGFloat = 200
    let tableViewCellTimeAndDescriptionStackHeight: CGFloat = 50
    let tableViewCellTemperatureLabelTrailingPadding: CGFloat = -20
    
    
    // MARK: ThreeHoursTableViewHeader
    let tableViewHeaderHeaderLabelFontSize: CGFloat = 18
    let tableViewHeaderHeaderLabelLeadingPadding: CGFloat = 20
}
