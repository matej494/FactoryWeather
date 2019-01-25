//
//  HomeRouter.swift
//  FactoryWeather
//
//  Created by Matej Korman on 08/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import Foundation

enum HomeNavigationOption {
    case settings
    case search
    case thisScene
}

protocol HomeRoutingLogic: class {
    func navigate(to option: HomeNavigationOption)
}

protocol HomeSceneDelegate: class { }

class HomeRouter {
    weak var delegate: HomeSceneDelegate?
    private var presenter: HomePresenter?
    private var viewController: HomeViewController?
    private var settingsRouter: SettingsRouter?
    private var searchRouter: SearchRouter?
    
    init(delegate: HomeSceneDelegate?) {
        self.delegate = delegate
    }
}

extension HomeRouter {
    func buildScene() -> HomeViewController {
        let viewController = HomeViewController()
        //TODO: Inject workers for testability
        let interactor = HomeInteractor()
        let presenter = HomePresenter(viewController: viewController, interactor: interactor)
        viewController.presenter = presenter
        presenter.router = self
        self.presenter = presenter
        self.viewController = viewController
        return viewController
    }
}

// MARK: - Routing Logic
extension HomeRouter: HomeRoutingLogic {
    func navigate(to option: HomeNavigationOption) {
        switch option {
        case .settings:
            let settingsRouter = SettingsRouter(delegate: presenter)
            let settingsViewController = settingsRouter.buildScene()
            self.settingsRouter = settingsRouter
            settingsViewController.modalPresentationStyle = .overCurrentContext
            viewController?.present(settingsViewController, animated: true, completion: nil)
        case .search:
            guard let viewController = viewController else { return }
            let searchRouter = SearchRouter(delegate: presenter)
            let searchViewController = searchRouter.buildScene(safeAreaInsets: viewController.view.safeAreaInsets)
            self.searchRouter = searchRouter
            searchViewController.transitioningDelegate = viewController
            searchViewController.modalPresentationStyle = .custom
            viewController.present(searchViewController, animated: true, completion: nil)
        case .thisScene:
            guard let viewController = viewController else { return }
            viewController.dismiss(animated: true, completion: nil)
            viewController.navigationController?.popToViewController(viewController, animated: true)
        }
    }
}
