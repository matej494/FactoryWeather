//
//  SearchTextField.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    var didTapOnSearchButton: ((String) -> Void)?
    private let searchButton = UIButton.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupSearchButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        return CGRect(x: superRect.origin.x + 15, y: superRect.origin.y, width: superRect.size.width - 30, height: superRect.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.rightViewRect(forBounds: bounds)
        return CGRect(x: superRect.origin.x - 15, y: superRect.origin.y, width: superRect.size.width, height: superRect.size.height)
    }
}

private extension SearchTextField {
    func setupProperties() {
        placeholder = LocalizationKey.Common.searchTextFieldPlaceholder.localized()
        backgroundColor = .white
        rightViewMode = .always
        layer.cornerRadius = 17
    }
    
    func setupSearchButton() {
        let tintedImage = #imageLiteral(resourceName: "search_icon").withRenderingMode(.alwaysTemplate)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchDown)
        searchButton.setImage(tintedImage, for: .normal)
        searchButton.tintColor = .factoryGreen
        rightView = searchButton
        searchButton.snp.makeConstraints { $0.width.height.equalTo(25) }
    }
    
    @objc func searchButtonTapped() {
        guard let text = text,
            !text.isEmpty
            else { return }
        didTapOnSearchButton?(text)
    }
}
