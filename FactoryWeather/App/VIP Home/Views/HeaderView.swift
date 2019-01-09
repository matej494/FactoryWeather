//
//  HeaderView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class HeaderView: UIView {
    typealias ViewModel = (headerImage: UIImage, currentTemperature: String, summary: String)
    
    private let safeAreaLayoutView = UIView.autolayoutView()
    private let backgroundImageView = UIImageView.autolayoutView()
    private let temperatureAndDescriptionView = TitleAndBodyView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderView {
    func updateProperties(withData data: ViewModel) {
        backgroundImageView.image = data.headerImage
        temperatureAndDescriptionView.titleText = data.currentTemperature
        temperatureAndDescriptionView.bodyText = data.summary
    }
}

private extension HeaderView {
    func setupViews() {
        setupSafeAreaLayoutView()
        setupTemperatureAndDescriptionView()
        setupBackgorundImageView()
    }
    
    func setupSafeAreaLayoutView() {
        addSubview(safeAreaLayoutView)
        safeAreaLayoutView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
    }
    
    func setupBackgorundImageView() {
        backgroundImageView.contentMode = .scaleAspectFill
        safeAreaLayoutView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupTemperatureAndDescriptionView() {
        temperatureAndDescriptionView.titleFontSize = 72
        temperatureAndDescriptionView.bodyFontSize = 24
        safeAreaLayoutView.addSubview(temperatureAndDescriptionView)
        temperatureAndDescriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
