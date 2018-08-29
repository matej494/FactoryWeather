//
//  BodyView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class BodyView: UIView {
    var didSelectSearchTextField: (() -> Void)?
    var didTapOnSettingsButton: (() -> Void)?
    
    private let safeAreaLayoutView = UIView.autolayoutView()
    private let mainStackView = UIStackView.autolayoutView()
    private let temperaturesView = UIView.autolayoutView()
    private let conditionsStackView = UIStackView.autolayoutView()
    private let cityLabel = UILabel.autolayoutView()
    private let temperatureSeparatorView = UIView.autolayoutView()
    private let lowTemperatureView = TitleAndBodyView.autolayoutView()
    private let highTemperatureView = TitleAndBodyView.autolayoutView()
    private let humidityView = ConditionIconAndValueView.autolayoutView()
    private let windView = ConditionIconAndValueView.autolayoutView()
    private let pressureView = ConditionIconAndValueView.autolayoutView()
    private let searchView = UIView.autolayoutView()
    private let settingsButton = UIButton.autolayoutView()
    private let searchTextField = SearchTextField.autolayoutView()
    private let backgroundImageView = UIImageView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BodyView {
    func updateProperties(withData data: HomeViewModel) {
        backgroundImageView.image = data.bodyImage
        cityLabel.text = data.cityName
        lowTemperatureView.titleText = data.lowTemperature
        highTemperatureView.titleText = data.highTemperature
        humidityView.value = data.humidity
        windView.value = data.windSpeed
        pressureView.value = data.pressure
        updateConditions(visibleConditions: data.visibleConditions)
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        searchView.isHidden = isHidden
    }
}

extension BodyView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        didSelectSearchTextField?()
        return false
    }
}

private extension BodyView {
    func updateConditions(visibleConditions: Conditions) {
        conditionsStackView.subviews.forEach({ $0.removeFromSuperview() })
        if visibleConditions.contains(.humidity) {
            conditionsStackView.addArrangedSubview(humidityView)
        }
        if visibleConditions.contains(.windSpeed) {
            conditionsStackView.addArrangedSubview(windView)
        }
        if visibleConditions.contains(.pressure) {
            conditionsStackView.addArrangedSubview(pressureView)
        }
    }
    
    @objc func settingsButtonTapped() {
        didTapOnSettingsButton?()
    }
}

private extension BodyView {
    func setupViews() {
        setupBackgroundImageView()
        setupSafeAreaLayoutView()
        setupMainStackView()
        setupCityLabel()
        setupTemperaturesView()
        setupConditionsStackView()
        setupTemperatureSeparatorView()
        setupLowTemperatureView()
        setupHighTemperatureView()
        setupHumidityView()
        setupWindView()
        setupPressureView()
        setupSearchView()
        setupSettingsButton()
        setupSearchLabel()
    }
    
    func setupBackgroundImageView() {
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.75)
        }
    }
    
    func setupSafeAreaLayoutView() {
        addSubview(safeAreaLayoutView)
        safeAreaLayoutView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
    }
    
    func setupMainStackView() {
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 20
        mainStackView.axis = .vertical
        safeAreaLayoutView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { $0.leading.top.trailing.equalToSuperview() }
    }
    
    func setupCityLabel() {
        cityLabel.font = .gothamRounded(type: .book, ofSize: 36)
        cityLabel.numberOfLines = 3
        cityLabel.textColor = .white
        cityLabel.textAlignment = .center
        mainStackView.addArrangedSubview(cityLabel)
    }
    
    func setupTemperaturesView() {
        mainStackView.addArrangedSubview(temperaturesView)
    }
    
    func setupConditionsStackView() {
        conditionsStackView.axis = .horizontal
        conditionsStackView.distribution = .fillEqually
        conditionsStackView.spacing = 10
        mainStackView.addArrangedSubview(conditionsStackView)
    }

    func setupTemperatureSeparatorView() {
        temperatureSeparatorView.backgroundColor = .white
        temperaturesView.addSubview(temperatureSeparatorView)
        temperatureSeparatorView.snp.makeConstraints({
            $0.centerX.top.bottom.equalToSuperview()
            $0.width.equalTo(2)
        })
    }

    func setupLowTemperatureView() {
        lowTemperatureView.titleFontSize = 24
        lowTemperatureView.bodyFontSize = 20
        lowTemperatureView.bodyText = LocalizationKey.Home.lowTemperatureDescriptionLabel.localized()
        temperaturesView.addSubview(lowTemperatureView)
        lowTemperatureView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(temperatureSeparatorView.snp.leading)
        }
    }
    
    func setupHighTemperatureView() {
        highTemperatureView.titleFontSize = 24
        highTemperatureView.bodyFontSize = 20
        highTemperatureView.bodyText = LocalizationKey.Home.highTemperatureDescriptionLabel.localized()
        temperaturesView.addSubview(highTemperatureView)
        highTemperatureView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(temperatureSeparatorView.snp.trailing)
        }
    }
    
    func setupHumidityView() {
        humidityView.iconImage = #imageLiteral(resourceName: "humidity_icon")
        humidityView.valueFontSize = 20
        conditionsStackView.addArrangedSubview(humidityView)
    }
    
    func setupWindView() {
        windView.iconImage = #imageLiteral(resourceName: "wind_icon")
        windView.valueFontSize = 20
        conditionsStackView.addArrangedSubview(windView)
    }
    
    func setupPressureView() {
        pressureView.iconImage = #imageLiteral(resourceName: "pressure_icon")
        pressureView.valueFontSize = 20
        conditionsStackView.addArrangedSubview(pressureView)
    }
    
    func setupSearchView() {
        safeAreaLayoutView.addSubview(searchView)
        searchView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(mainStackView.snp.bottom).inset(-20)
        }
    }
    
    func setupSettingsButton() {
        settingsButton.setImage(#imageLiteral(resourceName: "settings_icon"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchDown)
        settingsButton.setContentHuggingPriority(.required, for: .horizontal)
        searchView.addSubview(settingsButton)
        settingsButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupSearchLabel() {
        searchTextField.delegate = self
        searchTextField.rightView?.isUserInteractionEnabled = false
        searchTextField.setContentCompressionResistancePriority(.required, for: .vertical)
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(20)
            $0.leading.equalTo(settingsButton.snp.trailing).inset(-15)
            $0.height.equalTo(35)
        }
    }
}
