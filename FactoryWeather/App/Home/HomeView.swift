//
//  HomeView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit
//import CoreLocation

class HomeView: UIView {
    var didTapOnSettingsButton: (() -> Void)? {
        didSet { bodyView.didTapOnSettingsButton = didTapOnSettingsButton }
    }
    
    var didSelectSearchTextField: (() -> Void)? {
        didSet { bodyView.didSelectSearchTextField = didSelectSearchTextField }
    }
    
    private let skyView = UIView.autolayoutView()
    private let headerView = HeaderView.autolayoutView()
    private let bodyView = BodyView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    struct ViewModel {
        let currentTemperature: String
        let lowTemperature: String
        let highTemperature: String
        let humidity: String
        let windSpeed: String
        let pressure: String
        let cityName: String
        let summary: String
        let skyGradient: CAGradientLayer
        let headerImage: UIImage
        let bodyImage: UIImage
        let visibleConditions: Conditions
        
        init(weatherData data: Weather, settings: Settings) {
            currentTemperature = settings.unit.temperature(imperialValue: Int(data.temperature))
            lowTemperature = settings.unit.temperature(imperialValue: data.temperatureLow)
            highTemperature = settings.unit.temperature(imperialValue: data.temperatureHigh)
            humidity = settings.unit.humidity(value: data.humidity)
            windSpeed = settings.unit.windSpeed(imperialValue: data.windSpeed)
            pressure = settings.unit.pressure(value: data.pressure)
            cityName = data.locationName
            summary = data.summary
            skyGradient = SkyWeatherCondition.forIcon(data.icon).gradient
            headerImage = UIImage(named: "header_image-\(data.icon)") ?? #imageLiteral(resourceName: "header_image-clear-day")
            bodyImage = UIImage(named: "body_image-\(data.icon)") ?? #imageLiteral(resourceName: "body_image-clear-day")
            visibleConditions = settings.conditions
        }
    }
}

extension HomeView {
    func updateProperties(withData data: ViewModel) {
        skyView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        skyView.layer.addSublayer(data.skyGradient)
        headerView.updateProperties(withData: data)
        bodyView.updateProperties(withData: data)
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        bodyView.searchTextFieldIsHidden(isHidden)
    }
}

private extension HomeView {
    func setupViews() {
        setupSkyView()
        setupBodyView()
        setupHeaderView()
    }
    
    func setupSkyView() {
        addSubview(skyView)
        skyView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
    }
    
    func setupBodyView() {
        addSubview(bodyView)
        bodyView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.6)
        }
    }

    func setupHeaderView() {
        addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(bodyView.snp.top)
        }
    }
}
