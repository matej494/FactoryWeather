//
//  HomeViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import SnapKit

protocol HomeDisplayLogic: class {
    func displayWeather(_ weather: HomeDataSource, forLocation location: Location)
    func searchTextFieldIsHidden(_ isHidden: Bool)
}

class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    var router: HomeRoutingLogic?
    
    private let contentView = HomeContentView.autolayoutView()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    private var location = Location(name: "Zagreb", country: "HR", latitude: 45.8150, longitude: 15.9819)
    
    init(delegate: HomeRouterDelegate?) {
        super.init(nibName: nil, bundle: nil)
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        router.delegate = delegate
        self.interactor = interactor
        self.router = router
        setupCallbacks()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherForDeviceLocation()
    }
}

// MARK: - Display Logic
extension HomeViewController: HomeDisplayLogic {
    func displayWeather(_ weather: HomeDataSource, forLocation location: Location) {
        self.location = location
        contentView.updateProperties(withData: weather)
        activityIndicatorView.stopAnimating()
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        contentView.searchTextFieldIsHidden(isHidden)
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
        // setup title, background, navigation buttons, etc
        setupContentView()
        setupActivityIndicatorView()
    }
    
    func setupContentView() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        contentView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func setupCallbacks() {
        contentView.didTapOnSettingsButton = { [weak self] in
            guard let strongSelf = self else { return }
            self?.router?.openSettings(oldLocation: strongSelf.location)
        }
        contentView.didSelectSearchTextField = { [weak self] in self?.router?.openSearch() }
    }
    
    func getWeatherForDeviceLocation() {
        activityIndicatorView.startAnimating()
        interactor?.getWeatherForDeviceLocation()
    }
}
