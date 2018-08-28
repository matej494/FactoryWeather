//
//  LocationTableViewCell.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class LocationTableViewCell: UITableViewCell {
    var didTapOnButton: (() -> Void)?
    
    // NOTE: "buttonTitleLabel" is just temporary. Until appropriate asset for button image is acquired.
    private let buttonTitleLabel = UILabel.autolayoutView()
    private let button = UIButton.autolayoutView()
    private let label = UILabel.autolayoutView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationTableViewCell {
    func updateProperties(text: String) {
        label.text = text
    }
}

private extension LocationTableViewCell {
    @objc func tappedOnButton() {
        didTapOnButton?()
    }
}

private extension LocationTableViewCell {
    func setupViews() {
        backgroundColor = .none
        setupButton()
        setupButtonTitleLabel()
        setupLabel()
    }
    
    func setupButton() {
        button.setImage(#imageLiteral(resourceName: "square_checkmark_uncheck"), for: .normal)
        button.addTarget(self, action: #selector(tappedOnButton), for: .touchDown)
        button.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.height.width.equalTo(35)
        }
    }
    
    func setupButtonTitleLabel() {
        buttonTitleLabel.text = "X"
        buttonTitleLabel.textColor = .factoryPaleCyan
        contentView.addSubview(buttonTitleLabel)
        buttonTitleLabel.snp.makeConstraints { $0.center.equalTo(button.snp.center) }
    }
    
    func setupLabel() {
        label.textColor = .white
        label.font = .gothamRounded(type: .book, ofSize: 17)
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(button.snp.trailing).inset(-10)
        }
    }
}
