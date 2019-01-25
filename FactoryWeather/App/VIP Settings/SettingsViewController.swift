//
//  SettingsViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 09/01/2019.
//  Copyright © 2019 Matej Korman. All rights reserved.
//

import SnapKit

//NOTE: This is just an example and needs to be expanded and extracted into a protocol.
enum TableRefresh {
    case reloadData
    case reloadSections(IndexSet)
    case reloadRows([IndexPath])
}

protocol SettingsDisplayLogic: class {
    func reloadTableView(with option: TableRefresh)
}

class SettingsViewController: UIViewController {
    weak var presenter: SettingsPresenterProtocol?
    private let contentView = SettingsContentView.autolayoutView()
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
extension SettingsViewController: SettingsDisplayLogic {
    func reloadTableView(with option: TableRefresh) {
        let tableView = contentView.tableView
        switch option {
        case .reloadData:
            tableView.reloadData()
        case .reloadSections(let sections):
            tableView.reloadSections(sections, with: .automatic)
        case .reloadRows(let rows):
            tableView.reloadRows(at: rows, with: .automatic)
        }
    }
}

// MARK: - TableView DataSource methods
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.dataSource.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.dataSource.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = presenter?.dataSource.section(at: indexPath.section)?.row(at: indexPath.row) else {
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
        presenter?.didSelectRow(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .gothamRounded(type: .book, ofSize: 20)
        label.text = presenter?.dataSource.section(at: section)?.title
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

// MARK: - Cell button tapped methods
extension SettingsViewController {
    func didTapButton(atIndexPath indexPath: IndexPath) {
        presenter?.didTapButton(atIndexPath: indexPath)
    }
    
    func didTapButton(forCondition condition: Conditions, atIndexPath indexPath: IndexPath) {
        presenter?.didTapButton(forCondition: condition, atIndexPath: indexPath)
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
        presenter?.doneButtonTapped()
    }
}
