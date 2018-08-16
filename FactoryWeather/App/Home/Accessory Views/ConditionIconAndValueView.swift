//
//  ConditionIconAndValueView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class ConditionIconAndValueView: UIView {
    var value: String = "" {
        didSet { valueLabel.text = value }
    }
    var valueFontSize: CGFloat = 10 {
        didSet { valueLabel.font = .systemFont(ofSize: valueFontSize) }
    }
    var iconImage: UIImage? = nil {
        didSet { iconView.image = iconImage }
    }
    
    private let iconView = UIImageView.autolayoutView()
    private let valueLabel = UILabel.autolayoutView()
    
    init() {
        super.init(frame: CGRect.zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConditionIconAndValueView {
    func setupViews() {
        setupValueLabel()
        setupIconView()
    }

    func setupValueLabel() {
        valueLabel.font = .systemFont(ofSize: valueFontSize) // TODO: Implement Gotham Rounded Style
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(valueLabel.snp.top).inset(-20)
            $0.centerX.equalToSuperview()
            $0.height.lessThanOrEqualTo(valueLabel.snp.height).multipliedBy(3)
        }
    }
}
