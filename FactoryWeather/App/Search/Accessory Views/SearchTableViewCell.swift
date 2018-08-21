//
//  SearchTableViewCell.swift
//  FactoryWeather
//
//  Created by Matej Korman on 19/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    var nameLabelText: String? {
        didSet {
            nameLabel.text = nameLabelText
            guard let firstLetter = nameLabelText?.first
                else { return firstLetterLabel.text = nil }
            firstLetterLabel.text = String(firstLetter)
        }
    }
    
    private let firstLetterView = UIView.autolayoutView()
    private let firstLetterLabel = UILabel.autolayoutView()
    private let nameLabel = UILabel.autolayoutView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchTableViewCell {
    func setupViews() {
        backgroundColor = .none
        setupSelectedBackgroundView()
        setupFirstLetterView()
        setupFirstLetterLabel()
        setupNameLabel()
    }
    
    func setupSelectedBackgroundView() {
        let selectedBackgorundView = UIView()
        selectedBackgorundView.backgroundColor = .factoryDeepGreen
        selectedBackgroundView = selectedBackgorundView
    }
    
    func setupFirstLetterView() {
        firstLetterView.backgroundColor = .factoryLightBlue
        firstLetterView.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(firstLetterView)
        firstLetterView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(2)
            $0.top.bottom.equalToSuperview().inset(1)
        }
    }
    
    func setupFirstLetterLabel() {
        firstLetterLabel.font = .gothamRounded(type: .book, ofSize: 17)
        firstLetterLabel.textAlignment = .center
        firstLetterLabel.textColor = .white
        firstLetterLabel.setContentHuggingPriority(.required, for: .horizontal)
        firstLetterView.addSubview(firstLetterLabel)
        firstLetterLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.width.equalTo(40)
        }
    }
    
    func setupNameLabel() {
        nameLabel.font = .gothamRounded(type: .book, ofSize: 17)
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(firstLetterView.snp.trailing).inset(-10)
        }
    }
}
