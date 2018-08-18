//
//  TitleAndBodyView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class TitleAndBodyView: UIView {
    var titleText: String = "" {
        didSet { titleLabel.text = titleText }
    }
    var bodyText: String = "" {
        didSet { bodyLabel.text = bodyText }
    }
    var titleFontSize: CGFloat = 10 {
        didSet { titleLabel.font = .systemFont(ofSize: titleFontSize) }
    }
    var bodyFontSize: CGFloat = 10 {
        didSet { bodyLabel.font = .systemFont(ofSize: bodyFontSize) }
    }
    
    private let titleLabel = UILabel.autolayoutView()
    private let bodyLabel = UILabel.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TitleAndBodyView {
    func setupViews() {
        setupTitleLabel()
        setupBodyLabel()
    }
    
    func setupTitleLabel() {
        titleLabel.font = .gothamRounded(type: .light, ofSize: titleFontSize)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupBodyLabel() {
        bodyLabel.font = .gothamRounded(type: .light, ofSize: bodyFontSize)
        bodyLabel.textColor = .white
        bodyLabel.textAlignment = .center
        bodyLabel.setContentHuggingPriority(.required, for: .vertical)
        addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
}
