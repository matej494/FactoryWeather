//
//  ConditionsTableViewCell.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class ConditionsTableViewCell: UITableViewCell {
    typealias ViewModel = Conditions
    var didTapOnButton: ((Conditions) -> Void)?
    private let stackView = UIStackView.autolayoutView()
    private let humidityView = ConditionIconAndCheckBoxView.autolayoutView()
    private let windView = ConditionIconAndCheckBoxView.autolayoutView()
    private let pressureView = ConditionIconAndCheckBoxView.autolayoutView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConditionsTableViewCell {
    func updateProperties(conditions: ViewModel) {
        humidityView.isSelected = conditions.contains(.humidity)
        windView.isSelected = conditions.contains(.windSpeed)
        pressureView.isSelected = conditions.contains(.pressure)
    }
}

private extension ConditionsTableViewCell {
    @objc func tappedOnHumidityButton() {
        didTapOnButton?(Conditions.humidity)
    }
    
    @objc func tappedOnWindButton() {
        didTapOnButton?(Conditions.windSpeed)
    }
    
    @objc func tappedOnPressureButton() {
        didTapOnButton?(Conditions.pressure)
    }
}

private extension ConditionsTableViewCell {
    func setupViews() {
        backgroundColor = .none
        selectionStyle = .none
        setupStackView()
        setupHumidityView()
        setupWindView()
        setupPressureView()
    }
    
    func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupHumidityView() {
        humidityView.iconImage = #imageLiteral(resourceName: "humidity_icon")
        humidityView.didTapOnButton = tappedOnHumidityButton
        stackView.addArrangedSubview(humidityView)
    }
    
    func setupWindView() {
        windView.iconImage = #imageLiteral(resourceName: "wind_icon")
        windView.didTapOnButton = tappedOnWindButton
        stackView.addArrangedSubview(windView)
    }
    
    func setupPressureView() {
        pressureView.iconImage = #imageLiteral(resourceName: "pressure_icon")
        pressureView.didTapOnButton = tappedOnPressureButton
        stackView.addArrangedSubview(pressureView)
    }
}
