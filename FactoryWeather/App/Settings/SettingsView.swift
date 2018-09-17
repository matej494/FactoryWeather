//
//  SettingsView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 21/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SettingsView: UIView {
    let tableView = UITableView.autolayoutView()
    let doneButton = UIButton(type: .roundedRect).autolayoutView()
    
    private let safeAreaLayoutView = UIView.autolayoutView()
    private var blurredView = UIVisualEffectView().autolayoutView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingsView {
    func setupViews() {
        backgroundColor = UIColor(red: 80, green: 80, blue: 80, alpha: 0.5)
        setupBluredView()
        setupSafeAreaLayoutView()
        setupTableView()
        setupDoneButton()
    }
    
    func setupBluredView() {
        blurredView = UIVisualEffectView().autolayoutView()
        blurredView.effect = UIBlurEffect(style: .regular)
        addSubview(blurredView)
        blurredView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupSafeAreaLayoutView() {
        addSubview(safeAreaLayoutView)
        safeAreaLayoutView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
    }
    
    func setupTableView() {
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.register(UnitTableViewCell.self, forCellReuseIdentifier: UnitTableViewCell.identifier)
        tableView.register(ConditionsTableViewCell.self, forCellReuseIdentifier: ConditionsTableViewCell.identifier)
        safeAreaLayoutView.addSubview(tableView)
        tableView.snp.makeConstraints { $0.leading.trailing.top.equalToSuperview().inset(10) }
    }
    
    func setupDoneButton() {
        doneButton.backgroundColor = .white
        doneButton.setTitle(LocalizationKey.Settings.doneButtonTitle.localized(), for: .normal)
        doneButton.setTitleColor(.factoryGreen, for: .normal)
        doneButton.layer.cornerRadius = 20
        safeAreaLayoutView.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
            $0.top.equalTo(tableView.snp.bottom)
            $0.height.equalTo(40)
            $0.width.equalTo(90)
        }
    }
}
