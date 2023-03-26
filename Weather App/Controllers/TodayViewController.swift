//
//  TodayViewController.swift
//  Weather App
//
//  Created by bacho kartsivadze on 19.01.23.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController {
    
    private var myLocationLatitude: Double = 0.0
    private var myLocationLongitude: Double = 0.0
    private var newCity: String = ""
    private var data: [String] = []
    private var models: [CurrentWeather] = []
    private var currentPage = 0
    
    private var locationManager: CLLocationManager?
    
    private var collectionView: UICollectionView = {
        //layout
        let layout = DGCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: Constants.shared.collectionViewLayoutWidth, height: Constants.shared.collectionViewLayoutHeight)
        
        // view
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        view.backgroundColor = .clear
        return view
    }()
    
    
    private let addCityPopup = AddCityPopupView()
    let blurVisualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: .light)
        view.effect = blurEffect
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pageControl: UIPageControl = {
        let pageConrol = UIPageControl()
        pageConrol.backgroundColor = .clear
        pageConrol.translatesAutoresizingMaskIntoConstraints = false
        return pageConrol
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let addLocationButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill")
        button.setBackgroundImage(image, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.layer.shadowColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let errorView = ErrorView()
    private var notificationView = NotificationView()
    
    private let constants = Constants.shared

    //_______________________________________________________________________________________________________
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        addViews()
        setConstraintsForCurrentOrientation()
        addDelegates()
        addTargets()
        handleFirstLounch()
        findUserLocation()
        prepareData()
        addShadows()
        
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSomeViewFrames()
    }
    
    
            
    private func addViews() {
        // add
        view.addSubview(collectionView)
        view.addSubview(addLocationButton)
        view.addSubview(pageControl)
        view.addSubview(blurVisualEffectView)
        view.addSubview(errorView)
        view.addSubview(addCityPopup)
        view.addSubview(notificationView)
        view.addSubview(spinner)
        // hide
        errorView.isHidden = true
        blurVisualEffectView.isHidden = true
        addCityPopup.isHidden = true
        collectionView.isHidden = true
        addLocationButton.isHidden = true
        pageControl.isHidden = true
    }

    private func configureNavBar() {
        navigationItem.titleView = {
            let label = UILabel()
            label.text = "Today"
            label.textColor = .white
            let font = UIFont.systemFont(ofSize: constants.navBarFontSize, weight: .semibold)
            label.font = font
            return label
        }()
        let leftImige = UIImage(systemName: "arrow.clockwise")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImige, style: .done, target: self, action: #selector(refresh))
        navigationItem.leftBarButtonItem?.tintColor = .yellow

    }
    
    private func addDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func addTargets() {
        addLocationButton.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(pageControlDidChabge(_:)), for: .valueChanged)
        addCityPopup.addLocationButton.addTarget(self, action: #selector(handleTapAddLocationButton), for: .touchUpInside)
        addCityPopup.textfield.addTarget(self, action: #selector(handleChangeTextFieldText(sender:)), for: .editingChanged)
        errorView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        // gesture
        let blurGesture = UITapGestureRecognizer(target: self, action: #selector(refresh))
        blurVisualEffectView.addGestureRecognizer(blurGesture)
    }
    
    private func handleFirstLounch() {
        if UserDefaults.standard.bool(forKey: "isNotFirstLounch") == false {
            let cities: [String] = ["Tbilisi"]
            UserDefaults.standard.set(cities, forKey: "cities")
            UserDefaults.standard.set(true, forKey: "isNotFirstLounch")
            UserDefaults.standard.set(0, forKey: "currentPage")
        }
    }
    
    private func findUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    private func prepareData() {
        currentPage = UserDefaults.standard.integer(forKey: "currentPage")
        let cities = UserDefaults.standard.object(forKey: "cities") as! [String]
        data = cities
    }
    
    @objc private func deleteCell(longpressGestureRecognizer: UILongPressGestureRecognizer) {
        if (longpressGestureRecognizer.state == .began) {
            let location = longpressGestureRecognizer.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location) {
                let alert = UIAlertController(
                           title: "Delete?",
                           message: "Are you sure you want to delete \(data[indexPath.row]) from your weather?",
                           preferredStyle: .actionSheet
                       )
                       alert.addAction(UIAlertAction(
                           title: "Delete",
                           style: .destructive,
                           handler:  {[unowned self] _ in
                               deleteActualCell(at: indexPath)
                           }
                       )
                       )
                       alert.addAction(UIAlertAction(title: "Cancel", style: .default))
               
                       present(alert, animated: true)
            }
        }
    }
    
    private func deleteActualCell(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            showNotification(headerText: "Error Occured", secondaryText: "It's your location, can't delete", backGroundColor: .systemRed)
            return
        }
        if indexPath.row == data.count-1 {
            currentPage = currentPage-1
            UserDefaults.standard.set(currentPage, forKey: "currentPage")
            collectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            collectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)

        }
        updateLayoutAfterDelete(indexPath: indexPath)
    }
    
    private func updateLayoutAfterDelete(indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        models.remove(at: indexPath.row)
        pageControl.numberOfPages = data.count
        collectionView.deleteItems(at: [indexPath])
        UserDefaults.standard.set(data, forKey: "cities")
    }
    
    @objc private func handleChangeTextFieldText(sender: UITextField) {
        newCity = sender.text ?? "Error"
    }
    
    @objc private func handleTapAddLocationButton() {
        if newCity == "" {return}
        
        addCityPopup.spinner.isHidden = false // start spining
        addCityPopup.spinner.startAnimating()
        APICaller.shared.getCurrentWeatherWithCityName(at: newCity) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(_):
                    self.addCity(city: self.newCity)

                case.failure(_):
                    self.showNotification(headerText: "Error Occured", secondaryText: "City with that name was not fonund!", backGroundColor: .systemRed)
                }
                self.addCityPopup.spinner.stopAnimating() // end spinning
                self.addCityPopup.spinner.isHidden = true
            }
        }
    }
    
    private func addCity(city: String) {
        data.append(newCity)
        UserDefaults.standard.set(data, forKey: "cities")
        currentPage = data.count-1
        UserDefaults.standard.set(currentPage, forKey: "currentPage")
        refresh()
        pageControl.numberOfPages = data.count
        hidePopup()
    }
    
    @objc private func refresh() {
        prepareToRefresh()
        
        
        APICaller.shared.getCurrentWeatherWithCoordinates(lon: myLocationLongitude, lat: myLocationLatitude) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case.success(let model):
                    self.updateFirstModel(model: model)
                case.failure(let error):
                    print(error)
                    self.showError()
                }
            }
        }
        
        
        
        var startindex = 1
        if data.count == 1 {startindex = 0} // for the first run
        let endIndex = self.data.count-1
        
        for index in startindex...endIndex {
            APICaller.shared.getCurrentWeatherWithCityName(at: data[index]) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case.success(let model):
                        self.addModel(model: model)
                    case.failure(_):
                        self.showError()
                    }
                    self.spinner.stopAnimating()
                }
            }
        }
        
    }
    
    private func prepareToRefresh() {
        spinner.startAnimating()
        hideWeather()
        models.removeAll()
        models.append(CurrentWeather())
        addCityPopup.textfield.text = ""
    }
    
    private func updateFirstModel(model: CurrentWeather) {
        models[0] = model
        data[0] = model.name ?? "Tbilisi"
        UserDefaults.standard.set(data, forKey: "cities")
        showErrorIfUsersLocationNotExists()
        collectionView.reloadData()
        showWeather()
    }
    
    private func addModel(model: CurrentWeather) {
        models.append(model)
        if models.count == data.count {
            showErrorIfUsersLocationNotExists()
            sortDataInModels()
            collectionView.reloadData()
            showWeather()
        }
    }
    
    private func sortDataInModels() {
        var sortedModels: [CurrentWeather] = []
        sortedModels.append(models[0])
        for cityIndex in 1...data.count-1 {
            for modelIndex in 1...models.count-1 {
                if models[modelIndex].name == data[cityIndex] {
                    sortedModels.append(models[modelIndex])
                }
            }
        }
        models = sortedModels
    }
    
    private func showErrorIfUsersLocationNotExists() {
        if models[0].name != "Error" {return}
        showError()
    }
    
    @objc private func addLocation() {
        addCityPopup.isHidden = false
        blurVisualEffectView.isHidden = false
    }
    
    private func hidePopup() {
        addCityPopup.isHidden = true
        blurVisualEffectView.isHidden = true
        addCityPopup.textfield.text = ""
        errorView.isHidden = true
        blurVisualEffectView.isHidden = true
    }
    
    @objc private func pageControlDidChabge( _ sender: UIPageControl) {
        let current = sender.currentPage
        collectionView.scrollToItem(at: IndexPath(row: current, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func showWeather() {
        if errorView.isHidden == false {return}
        pageControl.numberOfPages = data.count
        spinner.isHidden = true
        collectionView.isHidden = false
        pageControl.isHidden = false
        addLocationButton.isHidden = false
        collectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func hideWeather() {
        addCityPopup.isHidden = true
        spinner.isHidden = false
        collectionView.isHidden = true
        pageControl.isHidden = true
        addLocationButton.isHidden = true
        errorView.isHidden = true
        blurVisualEffectView.isHidden = true
        spinner.startAnimating()
    }
    
    
    private func showError() {
        blurVisualEffectView.isHidden = false
        errorView.isHidden = false
        collectionView.isHidden = true
        addLocationButton.isHidden = true
        pageControl.isHidden = true
        errorView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
    }
    
    private func showNotification(headerText: String, secondaryText: String, backGroundColor: UIColor) {
        notificationView.configure(headerText: headerText, secondaryText: secondaryText, backGroundColor: backGroundColor)
        addCityPopup.textfield.text = ""
        
        
        UIView.animate(withDuration: constants.notificationAnimationShowDelay, animations: {
            self.notificationView.transform = CGAffineTransform(translationX: 0, y: self.constants.notificationScrollLength)
        })
        
        UIView.animate(withDuration: constants.notificationAnimationHideDelay, delay: constants.notificationAnimationDuration, animations: {
            self.notificationView.transform = .identity
        })
        
    }
    
    
    private func addShadows() {
        addShadow(to: notificationView)
        addShadow(to: addCityPopup)
        addShadow(to: blurVisualEffectView)
        addShadow(to: addLocationButton)
    }
    
    private func addShadow(to view: UIView){
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowRadius = constants.shadowRadius
        view.layer.shadowOpacity = constants.shadowOpacity
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        
        coordinator.animate(alongsideTransition: { context in
                self.collectionView.collectionViewLayout.invalidateLayout()
            }) { _ in
                
                self.removeConstraints()
                self.setConstraintsForCurrentOrientation()
                self.collectionView.reloadData()
                self.setSomeViewFrames()
        }
    }
    
    private func removeConstraints() {
        collectionView.removeConstraints(collectionView.constraints)
        addLocationButton.removeConstraints(addLocationButton.constraints)
        pageControl.removeConstraints(pageControl.constraints)
        
        view.removeConstraints(view.constraints)
    }
    
    private func setConstraintsForLandscape() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constants.collectionViewLeadingPaddingLandscape),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constants.collectionViewTrailingPaddingLandscape),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constants.collectionViewDeviationFromYAxisLandscape),
            collectionView.heightAnchor.constraint(equalToConstant: constants.collectionViewHeightLandscape),
            
            addLocationButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: constants.loctionButtonTopPaddingLandscape),
            addLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addLocationButton.heightAnchor.constraint(equalToConstant: constants.loctionButtonHeightLandscape),
            addLocationButton.widthAnchor.constraint(equalToConstant: constants.loctionButtonWidthLandscape),
            
            pageControl.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: constants.pageControlBottomPaddingLandscape),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: constants.pageControlHeightLandscape),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        addSharedConstraints()
    }
    
    
    private func setConstraintsForPortarait() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constants.collectionViewLeadingPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constants.collectionViewTrailingPadding),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constants.collectionViewDeviationFromYAxis),
            collectionView.heightAnchor.constraint(equalToConstant: constants.collectionViewHeight),
            
            addLocationButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: constants.loctionButtonTopPadding),
            addLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addLocationButton.heightAnchor.constraint(equalToConstant: constants.loctionButtonHeight),
            addLocationButton.widthAnchor.constraint(equalToConstant: constants.loctionButtonWidth),
            
            pageControl.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: constants.pageControlBottomPadding),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: constants.pageControlHeight),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        addSharedConstraints()
    }
    
    
    private func addSharedConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.widthAnchor.constraint(equalToConstant: constants.errorViewWidth),
            errorView.heightAnchor.constraint(equalToConstant: constants.errorViewHeight),
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            notificationView.widthAnchor.constraint(equalToConstant: constants.notificationViewWidth),
            notificationView.heightAnchor.constraint(equalToConstant: constants.notificationViewHeight),
            notificationView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: constants.notificationViewDeviationFromTop),
            notificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setSomeViewFrames() {
        blurVisualEffectView.frame = view.bounds
        addCityPopup.frame = CGRect(x: view.frame.width/2 - constants.addCityPopupWidth/2, y: view.frame.height/2 - constants.addCityPopupHeight/2, width: constants.addCityPopupWidth, height: constants.addCityPopupHeight)
    }
    
    
    private func setConstraintsForCurrentOrientation() {
        if UIDevice.current.orientation.isLandscape {
            let layout = DGCarouselFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = .init(width: constants.collectionViewLayoutWidthLandscape, height: constants.collectionViewLayoutHeightLandscape)
            collectionView.collectionViewLayout = layout
            setConstraintsForLandscape()
        } else {
            let layout = DGCarouselFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = .init(width: constants.collectionViewLayoutWidth, height: constants.collectionViewLayoutHeight)
            collectionView.collectionViewLayout = layout
            setConstraintsForPortarait()
        }
    }
    
}


// MARK: EXTENSIONS_____________________________________________________________________________________________________________

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as? CarouselCollectionViewCell else {return UICollectionViewCell()}
        
        if UIDevice.current.orientation.isLandscape {
            cell.mainsStack.axis = .horizontal
        } else {
            cell.mainsStack.axis = .vertical
        }
        
        addShadow(to: cell)
        
        if models.count > indexPath.row {
            cell.configure(with: models[indexPath.row])
        }
        
        let caruselGesture = UILongPressGestureRecognizer(target: self, action: #selector(deleteCell))
        cell.addGestureRecognizer(caruselGesture)
        
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: self.collectionView.frame.width/2 + scrollView.contentOffset.x,
                                  y: self.collectionView.frame.height/2 + scrollView.contentOffset.y)
        
        // center cell have to be bigger than side cells
        guard let indexPath = self.collectionView.indexPathForItem(at: centerPoint) else {return}
                
        guard let centerCell = self.collectionView.cellForItem(at: indexPath) as? CarouselCollectionViewCell else {return}
        centerCell.transformToLarge()
        
        let offSetX = centerPoint.x - centerCell.center.x
        if offSetX < constants.minOffSetToTransform || offSetX > constants.maxOffSetToTransform {
            centerCell.transformToStandart()
        }
        
        // for page control
        pageControl.currentPage = collectionView.indexPathForItem(at: centerPoint)!.row
        
        currentPage = indexPath.row
        UserDefaults.standard.set(currentPage, forKey: "currentPage")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation.isLandscape {
            return constants.itemSizeLandScape
        }
        
        return constants.itemSizePortrait
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return constants.collectionViewMinimumSpaceing
    }
}

extension TodayViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coordinate = manager.location?.coordinate
        self.myLocationLatitude = coordinate?.latitude ?? 0
        self.myLocationLongitude = coordinate?.longitude ?? 0
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        // Handle each case of location permissions
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            showNotification(headerText: "App has access to your location?", secondaryText: "if yes, Tap refresh Button to see", backGroundColor: .systemGreen)
            break
        case .denied, .notDetermined, .restricted:
            showNotification(headerText: "App don't have access to your location", secondaryText: "first cell will be entire globe weather instead", backGroundColor: .systemGreen)
            UserDefaults.standard.set(false, forKey: "isNotFirstLounch")
            UserDefaults.standard.set(0, forKey: "currentPage")
        @unknown default:
            showError()
        }
    }
}
