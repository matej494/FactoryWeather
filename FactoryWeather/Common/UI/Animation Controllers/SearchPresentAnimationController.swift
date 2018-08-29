//
//  SearchPresentAnimationController.swift
//  FactoryWeather
//
//  Created by Matej Korman on 24/08/2018.
//  Copyright © 2018 Matej Korman. All rights reserved.
//

import SnapKit

class SearchPresentAnimationController: NSObject {
    private var containerView: UIView?
    private let searchTextField = SearchTextField.autolayoutView()
    private let blurredView = UIVisualEffectView()
    private let coloredBackgroundView = UIView()
    
    override init() {
        super.init()
        setupObserver()
    }
}

extension SearchPresentAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let searchTransitionable = transitionContext.viewController(forKey: .to) as? SearchTransitionable
            else { return }
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        self.containerView = containerView
        
        setupBlurredView(withFrame: containerView.frame)
        setupColoredBackgroundView(withFrame: containerView.frame)
        containerView.addSubview(coloredBackgroundView)
        containerView.addSubview(blurredView)
        containerView.addSubview(searchTextField)
        setupSearchTextFieldConstraints(view: containerView)
        containerView.layoutIfNeeded()
        containerView.addSubview(toVC.view)
        toVC.view.isHidden = true
        searchTextField.snp.updateConstraints { $0.leading.trailing.equalTo(containerView.safeAreaLayoutGuide).inset(10) }
        UIView.animate(withDuration: duration,
                       animations: { [weak self] in
                        searchTransitionable.presentKeyboard()
                        searchTransitionable.searchTextFieldIsHidden(true)
                        self?.blurredView.alpha = 1
                        self?.coloredBackgroundView.alpha = 1
                        containerView.layoutIfNeeded() },
                       completion: { [weak self] finished in
                        toVC.view.isHidden = false
                        self?.coloredBackgroundView.removeFromSuperview()
                        self?.blurredView.removeFromSuperview()
                        self?.searchTextField.removeFromSuperview()
                        searchTransitionable.searchTextFieldIsHidden(false)
                        transitionContext.completeTransition(finished)
        })
    }
}

private extension SearchPresentAnimationController {
    func setupColoredBackgroundView(withFrame frame: CGRect) {
        coloredBackgroundView.frame = frame
        coloredBackgroundView.backgroundColor = UIColor(red: 80, green: 80, blue: 80, alpha: 0.5)
        coloredBackgroundView.alpha = 0
    }
    
    func setupBlurredView(withFrame frame: CGRect) {
        blurredView.frame = frame
        blurredView.effect = UIBlurEffect(style: .regular)
        blurredView.alpha = 0
    }
    
    func setupSearchTextFieldConstraints(view: UIView) {
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(35)
        }
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let containerView = containerView
            else { return }
        let keyboardHeight = endFrame.size.height
        searchTextField.snp.updateConstraints { $0.bottom.equalTo(containerView.safeAreaLayoutGuide).inset(keyboardHeight + 10 - containerView.safeAreaInsets.bottom) }
        containerView.layoutIfNeeded()
    }
}
