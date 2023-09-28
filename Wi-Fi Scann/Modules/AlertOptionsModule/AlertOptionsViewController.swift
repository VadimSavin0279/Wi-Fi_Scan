//
//  AlertOptionsViewController.swift
//  FaxApp
//
//  Created by Eugene on 5.05.2022.
//

import UIKit

final class AlertOptionsViewController: UIAlertController {
    
    weak var router: CloseRouterCoordinator?
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        let innerCompletion = { [router] in
            router?.lastClosed()
            completion?()
        }
        super.dismiss(animated: flag, completion: innerCompletion)
    }
}
