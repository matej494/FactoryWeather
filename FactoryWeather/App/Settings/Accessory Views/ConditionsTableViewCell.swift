//
//  ConditionsTableViewCell.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class ConditionsTableViewCell: UITableViewCell {
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
    func updateProperties(humidityIsSelected: Bool, windIsSelected: Bool, pressureIsSelected: Bool) {
        humidityView.isSelected = humidityIsSelected
        windView.isSelected = windIsSelected
        pressureView.isSelected = pressureIsSelected
    }
}

private extension ConditionsTableViewCell {
    func setupViews() {
        backgroundColor = .none
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
        stackView.addArrangedSubview(humidityView)
    }
    
    func setupWindView() {
        windView.iconImage = #imageLiteral(resourceName: "wind_icon")
        stackView.addArrangedSubview(windView)
    }
    
    func setupPressureView() {
        pressureView.iconImage = #imageLiteral(resourceName: "pressure_icon")
        stackView.addArrangedSubview(pressureView)
    }
}
