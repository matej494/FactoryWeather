//
//  SearchDismissAnimationController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 27/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SearchDismissAnimationController: NSObject {
    private var containerView: UIView?
    private let searchTextField = SearchTextField.autolayoutView()
    private let blurredView = UIVisualEffectView()
    private let coloredBackgroundView = UIView()
    
    override init() {
        super.init()
        setupObserver()
    }
}

extension SearchDismissAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? SearchDismissible
            else { return }
        let containerView = transitionContext.containerView
        self.containerView = containerView
        let duration = transitionDuration(using: transitionContext)
        
        setupBlurredView(withFrame: containerView.frame)
        setupColoredBackgroundView(withFrame: containerView.frame)
        containerView.addSubview(coloredBackgroundView)
        containerView.addSubview(blurredView)
        containerView.addSubview(searchTextField)
        let keyboardHeight = fromVC.dismissKeyboard()
        setupSearchTextFieldConstraints(with: keyboardHeight)
        containerView.layoutIfNeeded()
        fromVC.mainView.isHidden = true
        searchTextField.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(60)
            $0.trailing.equalToSuperview().inset(20)
        }
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
                        fromVC.searchTextFieldIsHidden(true)
                        self?.blurredView.alpha = 0
                        self?.coloredBackgroundView.alpha = 0
                        containerView.layoutIfNeeded() },
                       completion: { [weak self] finished in
                        self?.coloredBackgroundView.removeFromSuperview()
                        self?.blurredView.removeFromSuperview()
                        self?.searchTextField.removeFromSuperview()
                        fromVC.searchTextFieldIsHidden(false)
                        transitionContext.completeTransition(finished)
        })
    }
}

private extension SearchDismissAnimationController {
    func setupColoredBackgroundView(withFrame frame: CGRect) {
        coloredBackgroundView.frame = frame
        coloredBackgroundView.backgroundColor = UIColor(red: 80, green: 80, blue: 80, alpha: 0.5)
        coloredBackgroundView.alpha = 1
    }
    
    func setupBlurredView(withFrame frame: CGRect) {
        blurredView.frame = frame
        blurredView.effect = UIBlurEffect(style: .regular)
        blurredView.alpha = 1
    }
    
    func setupSearchTextFieldConstraints(with keyboardHeight: CGFloat) {
        let bottomInset = keyboardHeight == 0 ? 20 : keyboardHeight + 10
        searchTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(bottomInset)
            $0.height.equalTo(35)
        }
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        searchTextField.snp.updateConstraints { $0.bottom.equalToSuperview().inset(20) }
        containerView?.layoutIfNeeded()
    }
}
