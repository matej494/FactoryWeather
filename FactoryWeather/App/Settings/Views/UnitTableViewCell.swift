//
//  UnitTableViewCell.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class UnitTableViewCell: UITableViewCell {
    static let identifier = "UnitTableViewCell"

    typealias ViewModel = (unitName: String?, buttonIsSelected: Bool, didTapOnButton: (() -> Void))

    private var didTapOnButton: (() -> Void)?
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
    func updateProperties(viewModel: ViewModel) {
        label.text = viewModel.unitName
        button.isSelected = viewModel.buttonIsSelected
        didTapOnButton = viewModel.didTapOnButton
    }
}

private extension UnitTableViewCell {
    @objc func tappedOnButton() {
        didTapOnButton?()
    }
}

private extension UnitTableViewCell {
    func setupViews() {
        backgroundColor = .none
        selectionStyle = .none
        setupButton()
        setupLabel()
    }
    
    func setupButton() {
        button.setImage(#imageLiteral(resourceName: "square_checkmark_check"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "square_checkmark_uncheck"), for: .normal)
        button.addTarget(self, action: #selector(tappedOnButton), for: .touchDown)
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
