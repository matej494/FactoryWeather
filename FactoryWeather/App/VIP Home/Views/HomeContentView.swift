//
//  HomeContentView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import SnapKit

class HomeContentView: UIView {
    typealias ViewModel = (skyGradient: CAGradientLayer, headerViewModel: HeaderView.ViewModel, bodyViewModel: BodyView.ViewModel)
    
    var didTapOnSettingsButton: (() -> Void)? {
        didSet { bodyView.didTapOnSettingsButton = didTapOnSettingsButton }
    }
    
    var didSelectSearchTextField: (() -> Void)? {
        didSet { bodyView.didSelectSearchTextField = didSelectSearchTextField }
    }
    
    private let skyView = UIView.autolayoutView()
    private let headerView = HeaderView.autolayoutView()
    private let bodyView = BodyView.autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeContentView {
    func updateProperties(withData data: ViewModel) {
        skyView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        skyView.layer.addSublayer(data.skyGradient)
        headerView.updateProperties(withData: data.headerViewModel)
        bodyView.updateProperties(withData: data.bodyViewModel)
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        bodyView.searchTextFieldIsHidden(isHidden)
    }
}

private extension HomeContentView {
    func setupViews() {
        setupSkyView()
        setupBodyView()
        setupHeaderView()
    }
    
    func setupSkyView() {
        addSubview(skyView)
        skyView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.5)
        }
    }
    
    func setupBodyView() {
        addSubview(bodyView)
        bodyView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.6)
        }
    }
    
    func setupHeaderView() {
        addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(bodyView.snp.top)
        }
    }
}
