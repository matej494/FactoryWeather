//
//  SearchTextField.swift
//  FactoryWeather
//
//  Created by Matej Korman on 14/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import UIKit

class SearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        return CGRect(x: superRect.origin.x + 10, y: superRect.origin.y, width: superRect.size.width - 20, height: superRect.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.rightViewRect(forBounds: bounds)
        return CGRect(x: superRect.origin.x - 10, y: superRect.origin.y, width: superRect.size.width, height: superRect.size.height)
    }
}

private extension SearchTextField {
    func setupProperties() {
        placeholder = "Search" // TODO: Localize
        backgroundColor = .white
        rightViewMode = .always
        rightView = UIImageView(image: #imageLiteral(resourceName: "search_icon"))
        layer.cornerRadius = 17
    }
}
