//
//  ConditionIconAndCheckBoxView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class ConditionIconAndCheckBoxView: UIView {
    var didTapOnButton: (() -> Void)?
    var isSelected = false {
        didSet { button.isSelected = isSelected }
    }

    var iconImage: UIImage? = nil {
        didSet { iconView.image = iconImage }
    }
    
    private let iconView = UIImageView.autolayoutView()
    private let button = UIButton.autolayoutView()
    
    init() {
        super.init(frame: CGRect.zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConditionIconAndCheckBoxView {
    @objc func tappedOnButton() {
        didTapOnButton?()
    }
}

private extension ConditionIconAndCheckBoxView {
    func setupViews() {
        setupIconView()
        setupCheckBoxButton()
    }
    
    func setupIconView() {
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.leading.top.trailing.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
    }
    
    func setupCheckBoxButton() {
        button.setImage(#imageLiteral(resourceName: "checkmark_check"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        button.addTarget(self, action: #selector(tappedOnButton), for: .touchDown)
        addSubview(button)
        button.snp.makeConstraints {
            $0.leading.trailing.bottom.centerX.equalToSuperview()
            $0.top.equalTo(iconView.snp.bottom).inset(-20)
            $0.height.equalTo(30)
        }
    }
}
