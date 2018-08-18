//
//  HeaderView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class HeaderView: UIView {
    private let backgroundImageView = UIImageView.autolayoutView()
    private let temperatureAndDescriptionView = TitleAndBodyView().autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderView {
    func updateProperties(withData data: HomeViewModel) {
        backgroundImageView.image = data.headerImage
        temperatureAndDescriptionView.titleText = data.currentTemperature
        temperatureAndDescriptionView.bodyText = data.summary
    }
}

private extension HeaderView {
    func setupViews() {
        setupTemperatureAndDescriptionView()
        setupBackgorundImageView()
    }
    
    func setupBackgorundImageView() {
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupTemperatureAndDescriptionView() {
        temperatureAndDescriptionView.titleFontSize = 72
        temperatureAndDescriptionView.bodyFontSize = 24
        addSubview(temperatureAndDescriptionView)
        temperatureAndDescriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
