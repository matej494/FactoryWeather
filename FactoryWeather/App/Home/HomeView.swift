//
//  HomeView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class HomeView: UIView {
    var didSelectSearchTextField: (() -> Void)? {
        didSet {
            bodyView.didSelectSearchTextField = didSelectSearchTextField
        }
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

extension HomeView {
    func updateProperties(withData data: HomeViewModel) {
        skyView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        skyView.layer.addSublayer(data.skyGradient)
        headerView.updateProperties(withData: data)
        bodyView.updateProperties(withData: data)
    }
}

private extension HomeView {
    func setupViews() {
        setupSkyView()
        setupBodyView()
        setupHeaderView()
    }
    
    func setupSkyView() {
        addSubview(skyView)
        skyView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.4)
        }
    }
    
    func setupBodyView() {
        addSubview(bodyView)
        bodyView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(skyView.snp.bottom)
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
