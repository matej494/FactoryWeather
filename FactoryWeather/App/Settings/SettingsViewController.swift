//
//  SettingsViewController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SettingsViewController: UIViewController {
    // NOTE: Dummy data.
    let locations = ["London, GB", "London, CA", "East Lonodn, SA"]
    let selectedUnit = [true, false]
    private let settingsView = SettingsView.autolayoutView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allValuesCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = SettingsSection(rawValue: section)?.count
            else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SettingsSection.locations.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(text: locations[indexPath.row])
            return cell
        } else if indexPath.section == SettingsSection.units.rawValue {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UnitTableViewCell", for: indexPath) as? UnitTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(unitName: Unit.allNames[indexPath.row], isSelected: selectedUnit[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConditionsTableViewCell", for: indexPath) as? ConditionsTableViewCell
                else { return UITableViewCell() }
            cell.updateProperties(humidityIsSelected: true, windIsSelected: true, pressureIsSelected: true)
            return cell
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .gothamRounded(type: .book, ofSize: 20)
        label.text = SettingsSection(rawValue: section)?.localizedName
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

private extension SettingsViewController {
    func setupView() {
        view.backgroundColor = .none
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
        settingsView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchDown)
        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
    }
    
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
