//
//  ViewModel.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import UIKit

protocol ViewControllerModel: AnyObject {
    var navigationTitle: String { get set }
    var viewContollerDelegate: ViewControllerModelDelegate? { get set }
}

protocol ViewControllerModelDelegate: AnyObject {
    func presentAlert(title: String, message: String?, actionTitle: String?, actionHandler: (() -> Void)?)
    func toggleLoadingInterface(_ flag: Bool)
}

// MARK: - ViewModelControllerDelegate View Controller Implementation

extension ViewControllerModelDelegate where Self: UIViewController {
    func presentAlert(title: String, message: String?, actionTitle: String? = nil, actionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        if let actionTitle = actionTitle, let handler = actionHandler {
            let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in handler() })
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
