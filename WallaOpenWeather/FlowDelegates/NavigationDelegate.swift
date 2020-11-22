//
//  NavigationDelegate.swift
//  AppIconMaker
//
//  Created by Eilon Krauthammer on 05/11/2020.
//

import UIKit

class NavigationDelegate: NSObject, UINavigationControllerDelegate {
    typealias Handler = (Coordinator?) -> Void
    
    let didFinish: Handler
    
    init(_ handler: @escaping Handler) {
        self.didFinish = handler
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let coordinatedViewController = fromViewController as? CoordinatedAdapter {
            didFinish(coordinatedViewController.coordinatorAdapter)
        }
    }
}
