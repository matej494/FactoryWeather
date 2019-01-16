//
//  SearchContentView.swift
//  FactoryWeather
//
//  Created by Matej Korman on 18/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SearchContentView: UIView {
    let tableView = UITableView.autolayoutView()
    var textFieldTextChanged: ((String) -> Void)?
    var didTapOnDismissButton: (() -> Void)?
    var didTapOnSearchButton: ((String) -> Void)? {
        didSet { searchTextField.didTapOnSearchButton = didTapOnSearchButton }
    }

    private let safeAreaLayoutView = UIView.autolayoutView()
    // NOTE: "dismissButtonTitleLabel" is just temporary. Until appropriate asset for button image is acquired.
    private let dismissButtonTitleLabel = UILabel.autolayoutView()
    private let dismissButton = UIButton.autolayoutView()
    private var blurredView = UIVisualEffectView().autolayoutView()
    private let searchTextField = SearchTextField.autolayoutView()
    private let keyboardSizedView = UIView.autolayoutView()
    private let bottomSafeAreaInset: CGFloat
    
    init(bottomSafeAreaInset: CGFloat) {
        self.bottomSafeAreaInset = bottomSafeAreaInset
        super.init(frame: CGRect.zero)
        setupViews()
        setupObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchContentView {
    func dismissKeyboard() -> CGFloat {
        let keyboardHeight = keyboardSizedView.frame.size.height
        searchTextField.resignFirstResponder()
        return keyboardHeight
    }
    
    func presentKeyboard() {
        searchTextField.becomeFirstResponder()
    }
}

private extension SearchContentView {
    func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldTextDidChange),
                                               name: NSNotification.Name.UITextFieldTextDidChange,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        let keyboardHeight = endFrame.size.height
        keyboardSizedView.snp.updateConstraints {
            $0.height.equalTo(keyboardHeight - bottomSafeAreaInset)
            $0.top.equalTo(searchTextField.snp.bottom).inset(-10)
        }
        layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardSizedView.snp.updateConstraints {
            $0.height.equalTo(0)
            $0.top.equalTo(searchTextField.snp.bottom).inset(-20)
        }
        layoutIfNeeded()
    }
    
    @objc func textFieldTextDidChange(notification: NSNotification) {
        textFieldTextChanged?(searchTextField.text ?? "")
    }
    
    @objc func dismissButtonTapped() {
        didTapOnDismissButton?()
    }
}

private extension SearchContentView {
    func setupViews() {
        backgroundColor = UIColor(red: 80, green: 80, blue: 80, alpha: 0.5)
        setupBluredView()
        setupSafeAreaLayoutView()
        setupTableView()
        setupDismissButton()
        setupDismissButtonTitleLabel()
        setupSearchTextField()
        setupKeyboardSizedView()
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
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        safeAreaLayoutView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
    }
    
    func setupDismissButton() {
        dismissButton.setImage(#imageLiteral(resourceName: "checkmark_uncheck"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchDown)
        safeAreaLayoutView.addSubview(dismissButton)
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setupDismissButtonTitleLabel() {
        dismissButtonTitleLabel.text = "X"
        dismissButtonTitleLabel.textColor = .factoryPaleCyan
        safeAreaLayoutView.addSubview(dismissButtonTitleLabel)
        dismissButtonTitleLabel.snp.makeConstraints { $0.center.equalTo(dismissButton.snp.center) }
    }
    
    func setupSearchTextField() {
        safeAreaLayoutView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(tableView.snp.bottom).inset(-20)
            $0.height.equalTo(35)
        }
    }
    
    func setupKeyboardSizedView() {
        safeAreaLayoutView.addSubview(keyboardSizedView)
        keyboardSizedView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(searchTextField.snp.bottom).inset(-20)
            $0.height.equalTo(0)
        }
    }
}
