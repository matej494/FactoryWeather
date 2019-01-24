//
//  HomeViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import SnapKit

protocol HomeDisplayLogic: class {
    func displayWeather(_ weather: HomeContentView.ViewModel, forLocation location: Location)
    func showActivityIndicator(_ shouldShow: Bool)
    func setSearchTextFieldHidden(_ isHidden: Bool)
}

class HomeViewController: UIViewController {
    weak var presenter: HomePresenterProtocol?
    private let contentView = HomeContentView.autolayoutView()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
}

// MARK: - Display Logic
extension HomeViewController: HomeDisplayLogic {
    func displayWeather(_ weather: HomeContentView.ViewModel, forLocation location: Location) {
        contentView.updateProperties(withData: weather)
    }
    
    func showActivityIndicator(_ shouldShow: Bool) {
        shouldShow ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
    
    func setSearchTextFieldHidden(_ hidden: Bool) {
        contentView.searchTextFieldIsHidden(hidden)
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presented is SearchViewController ? SearchPresentAnimationController() : nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissed is SearchViewController ? SearchDismissAnimationController() : nil
    }
}

// MARK: - Private Methods
private extension HomeViewController {
    func setupViews() {
        view.backgroundColor = .white
        setupContentView()
        setupActivityIndicatorView()
    }
    
    func setupContentView() {
        contentView.didTapOnSettingsButton = { [weak self] in
            self?.presenter?.settingsButtonTapped()
        }
        contentView.didSelectSearchTextField = { [weak self] in self?.presenter?.searchTextFieldSelected() }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}
