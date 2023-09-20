//
//  NavigationController.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import UIKit
import Combine

final class NavigationController: UINavigationController {
    
    var popActionPublisher: AnyPublisher<PopNavigationAction, Never> {
        popActionSubject.eraseToAnyPublisher()
    }
    
    var presentationDismissActionPublisher: AnyPublisher<PresentationDismissAction, Never> {
        presentationDismissActionSubject.eraseToAnyPublisher()
    }
    
    var modalDismissActionPublisher: AnyPublisher<ModalDismissAction, Never> {
        modalDismissActionSubject.eraseToAnyPublisher()
    }
    
    private let popActionSubject = PassthroughSubject<PopNavigationAction, Never>()
    private let presentationDismissActionSubject = PassthroughSubject<PresentationDismissAction, Never>()
    private let modalDismissActionSubject = PassthroughSubject<ModalDismissAction, Never>()
    private let bgColor: UIColor
    
    private var lastPoppedAction: (popped: UIViewController, presented: UIViewController)?
    private var lastPresentationDismissController: UIViewController?
    
    init(rootViewController: UIViewController,
         bgColor: UIColor = .white) {
        self.bgColor = bgColor
        super.init(rootViewController: rootViewController)
        self.presentationController?.delegate = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeBottomBorder()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        sendDismissAction(action: .willDismiss, viewController: self)
        let completion = { [weak self] in
            guard let self = self else { return }
            self.sendDismissAction(action: .didDismiss, viewController: self)
            completion?()
        }
        super.dismiss(animated: flag, completion: completion)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if !(viewControllerToPresent is UIAlertController) {
            viewControllerToPresent.presentationController?.delegate = self
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        if let vc = vc, let last = viewControllers.last {
            lastPoppedAction = (vc, last)
        }
        return vc
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.viewControllers.contains(where: { $0 === viewController }) {
            sendPopAction(action: .popTo, viewController: viewController)
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    // MARK: - Private methods
    
    private func sendDismissAction(action: ModalDismissAction.Action,
                                   viewController: UIViewController) {
        modalDismissActionSubject.send(
            ModalDismissAction(action: action,
                               navController: self,
                               viewController: viewController
                              )
        )
    }
    
    private func sendPopAction(action: PopNavigationAction.Action,
                               viewController: UIViewController) {
        popActionSubject.send(
            PopNavigationAction(
                action: action,
                navController: self,
                viewController: viewController
            )
        )
    }
    
    private func sendPresentationDismissAction(action: PresentationDismissAction.Action,
                                               viewController: UIViewController) {
        presentationDismissActionSubject.send(
            PresentationDismissAction(
                action: action,
                navController: self,
                viewController: viewController
            )
        )
    }
}

extension NavigationController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        sendPresentationDismissAction(
            action: .willDismiss,
            viewController: presentationController.presentedViewController
        )
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        sendPresentationDismissAction(
            action: .didDismiss,
            viewController: presentationController.presentedViewController
        )
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        
        guard let lastPoppedAction = lastPoppedAction else {
            return
        }
        
        self.lastPoppedAction = nil
        
        if lastPoppedAction.presented === viewController {
            sendPopAction(action: .pop, viewController: lastPoppedAction.popped)
        }
    }
}

extension UINavigationController {
    func applyBarColor(_ color: UIColor) {
        navigationBar.backgroundColor = color
        navigationBar.barTintColor = color
    }
    
    func removeBottomBorder() {
        navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
    
    func restoreBottomBorder() {
        navigationBar.setBackgroundImage(nil, for:.default)
        navigationBar.shadowImage = nil
        navigationBar.layoutIfNeeded()
    }
}

extension UIViewController {
    func applyNavigationBarColor(_ color: UIColor) {
        navigationController?.navigationBar.backgroundColor = color
        navigationController?.navigationBar.barTintColor = color
    }
    
    func removeNavigationBottomBorder() {
        self.navigationController?.removeBottomBorder()
    }
    
    func restoreNavigationBottomBorder() {
        self.navigationController?.restoreBottomBorder()
    }
}
