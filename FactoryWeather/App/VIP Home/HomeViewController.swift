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
}

protocol HomeSceneLogic: class {
    /**
     - Parameters:
        - forLocation: If this parameter is `nil`, current location will be used
        - completion: Called when weather is successfully received
     */
    func getWeather(forLocation location: Location?, completion: @escaping () -> Void)
    func setSearchTextFieldHidden(_ hidden: Bool)
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
    func displayWeather(_ weather: HomeContentView.ViewModel, forLocation location: Location) {
        self.location = location
        contentView.updateProperties(withData: weather)
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Scene Logic
extension HomeViewController: HomeSceneLogic {
    func getWeather(forLocation location: Location?, completion: @escaping () -> Void) {
        interactor?.getWeather(forLocation: location ?? self.location, completion: completion)
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
            guard let strongSelf = self else { return }
            self?.router?.openSettings(oldLocation: strongSelf.location)
        }
        contentView.didSelectSearchTextField = { [weak self] in self?.router?.openSearch() }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    func getWeatherForDeviceLocation() {
        activityIndicatorView.startAnimating()
        interactor?.getWeatherForDeviceLocation()
    }
}
