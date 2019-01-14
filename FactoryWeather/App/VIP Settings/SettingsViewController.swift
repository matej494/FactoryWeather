//
//  SettingsViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import SnapKit

protocol SettingsDisplayLogic: class {
    func displayLocations(_ locations: [Location])
    func initializeDisplay(locations: [Location], settings: Settings)
}

class SettingsViewController: UIViewController {
    var interactor: SettingsBusinessLogic?
    var router: SettingsRoutingLogic?
    
    private let contentView = SettingsContentView.autolayoutView()
    private let activityIndicatorView = UIActivityIndicatorView.autolayoutView()
    private var dataSource = SettingsDataSource()
    
    init(delegate: SettingsRouterDelegate?) {
        super.init(nibName: nil, bundle: nil)
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
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
        interactor?.getInitailData()
    }
}

// MARK: - Display Logic
extension SettingsViewController: SettingsDisplayLogic {
    func displayLocations(_ locations: [Location]) {
        dataSource.setLocations(locations)
        if let index = dataSource.sections.firstIndex(where: { $0 == SettingsSection.locations(rows: []) }) {
            contentView.tableView.reloadSections([index], with: .automatic)
        }
    }
    
    func initializeDisplay(locations: [Location], settings: Settings) {
        dataSource.setNewValues(locations: locations, settings: settings)
        contentView.tableView.reloadData()
    }
}

// MARK: - TableView DataSource methods
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = dataSource.section(at: indexPath.section)?.row(at: indexPath.row) else {
            return UITableViewCell()
        }
        switch row {
        case .locations(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.defaultReuseIdentifier, for: indexPath) as? LocationTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(text: viewModel)
            cell.didTapOnButton = { [weak self] in self?.didTapButton(atIndexPath: indexPath) }
            return cell
        case .units(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UnitTableViewCell.defaultReuseIdentifier, for: indexPath) as? UnitTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(data: viewModel)
            cell.didTapOnButton = { [weak self] in self?.didTapButton(atIndexPath: indexPath) }
            return cell
        case .conditions(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConditionsTableViewCell.defaultReuseIdentifier, for: indexPath) as? ConditionsTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(conditions: viewModel)
            cell.didTapOnButton = { [weak self] condition in self?.didTapButton(forCondition: condition, atIndexPath: indexPath) }
            return cell
        }
    }
}

// MARK: - TableView Delegate methods
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = dataSource.section(at: indexPath.section) else {
            return
        }
        switch section {
        case .locations:
            if let selectedLocation = dataSource.locations?[safe: indexPath.row] {
                dataSource.selectedLocation = selectedLocation
            }
        case .units, .conditions:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .gothamRounded(type: .book, ofSize: 20)
        label.text = dataSource.section(at: section)?.title
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

// MARK: - Cell button tapped methods
extension SettingsViewController {
    func didTapButton(atIndexPath indexPath: IndexPath) {
        guard let section = dataSource.section(at: indexPath.section) else {
            return
        }
        switch section {
        case .locations:
            if let location = dataSource.locations?[safe: indexPath.row] {
                interactor?.deleteLocation(location)
            }
        case .units:
            if var settings = dataSource.settings {
                settings.unit.toggle()
                dataSource.setSettings(settings: settings)
                contentView.tableView.reloadSections([indexPath.section], with: .none)
            }
        case .conditions:
            break
        }
    }
    
    func didTapButton(forCondition condition: Conditions, atIndexPath indexPath: IndexPath) {
        if var settings = dataSource.settings {
            settings.conditions.toggle(condition: condition)
            dataSource.setSettings(settings: settings)
            contentView.tableView.reloadSections([indexPath.section], with: .none)
        }
    }
}

// MARK: - Private Methods
private extension SettingsViewController {
    func setupViews() {
        view.backgroundColor = .none
        setupContentView()
        setupActivityIndicatorView()
    }
    
    func setupContentView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.defaultReuseIdentifier)
        contentView.tableView.register(UnitTableViewCell.self, forCellReuseIdentifier: UnitTableViewCell.defaultReuseIdentifier)
        contentView.tableView.register(ConditionsTableViewCell.self, forCellReuseIdentifier: ConditionsTableViewCell.defaultReuseIdentifier)
        contentView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchDown)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}

// MARK: - Private @objc Methods
private extension SettingsViewController {
    @objc func doneButtonTapped() {
        guard let settings = dataSource.settings else { return }
        interactor?.doneTapped(selectedLocation: dataSource.selectedLocation, settings: settings) { [weak self] shouldUpdateWeather in
            if shouldUpdateWeather {
                self?.router?.getNewWeather(selectedLocation: self?.dataSource.selectedLocation)
            }
            self?.router?.dismissSettingsScene()
        }
    }
}
