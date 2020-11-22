//
//  Coordinator.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import UIKit

// MARK: - Coordinator

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var children: [Coordinator] { get set }
    
    func start()
    
    /// Loops through all children coordinators
    func childDidFinish(_ child: Coordinator?, completion: (() -> Void)?)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?, completion: (() -> Void)? = .none) {
        for (index, coordiantor) in children.enumerated() {
            if child === coordiantor {
                children.remove(at: index)
                break
            }
        }
        completion?()
    }
}

// MARK: - Coordinated + Adapter

protocol CoordinatedAdapter {
    /// An adapted coordinator.
    var coordinatorAdapter: Coordinator? { get }
}

protocol Coordinated: AnyObject, CoordinatedAdapter {
    associatedtype T: Coordinator
    var coordinator: T? { get set }
}

extension Coordinated {
    var coordinatorAdapter: Coordinator? { coordinator }
}

