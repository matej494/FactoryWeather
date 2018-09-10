//
//  HomeViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 13/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let homeView = HomeView.autolayoutView()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

private extension HomeViewController {
    func setupView() {
        setupCallbacks()
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
        activityIndicatorView.startAnimating()
    }
    
    func setupCallbacks() {
        homeView.didSelectSearchTextField = { [weak self] in
            guard let strongSelf = self
                else { return }
            let searchViewModelImpl = SearchViewModelImpl()
            searchViewModelImpl.selectedLocation.bind({ [weak self] location in
                guard let location = location
                    else { return }
                self?.viewModel.dataChanged(location)
            })
            searchViewModelImpl.weather.bind({ [weak self] weather in
                guard let weather = weather
                    else { return }
                self?.viewModel.dataChanged(weather)
            })
            let searchViewController = SearchViewController(viewModel: searchViewModelImpl, safeAreaInsets: strongSelf.view.safeAreaInsets)
            searchViewController.searchTextFieldIsHidden = { [weak self] isHidden in
                self?.searchTextFieldIsHidden(isHidden)
            }
            searchViewController.transitioningDelegate = self
            searchViewController.modalPresentationStyle = .custom
            strongSelf.present(searchViewController, animated: true, completion: nil)
        }
        homeView.didTapOnSettingsButton = { [weak self] in
            guard let strongSelf = self
                else { return }
            let settingsViewModel = SettingsViewModelImpl(oldLocation: strongSelf.viewModel.location)
            settingsViewModel.selectedLocation.bind { [weak self] location in
                guard let location = location
                    else { return }
                self?.viewModel.dataChanged(location)
            }
            settingsViewModel.weather.bind { [weak self] weather in
                guard let weather = weather
                    else { return }
                self?.viewModel.dataChanged(weather)
            }
            settingsViewModel.settings.bind { [weak self] settings in
                self?.viewModel.dataChanged(settings)
            }
            let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
            settingsViewController.modalPresentationStyle = .overCurrentContext
            strongSelf.present(settingsViewController, animated: true, completion: nil)
        }
        viewModel.weather.bind { [weak self] weather in
            guard let weather = weather,
                let settings = self?.viewModel.settings
                else { return }
            let homeViewViewModel = HomeView.ViewModel(weatherData: weather, settings: settings)
            self?.homeView.updateProperties(withData: homeViewViewModel)
        }
        viewModel.waitingResponse.bind { [weak self] isWaiting in
            if isWaiting {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func searchTextFieldIsHidden(_ isHidden: Bool) {
        homeView.searchTextFieldIsHidden(isHidden)
    }
}
