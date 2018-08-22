//
//  UnitTableViewCell.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class UnitTableViewCell: UITableViewCell {
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

extension UnitTableViewCell {
    func updateProperties(unitName: String, isSelected: Bool) {
        label.text = unitName
        button.isSelected = isSelected
    }
}

private extension UnitTableViewCell {
    func setupViews() {
        backgroundColor = .none
        setupButton()
        setupLabel()
    }
    
    func setupButton() {
        button.setImage(#imageLiteral(resourceName: "square_checkmark_check"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "square_checkmark_uncheck"), for: .normal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.height.width.equalTo(35)
        }
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
