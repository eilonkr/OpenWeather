//
//  BaseController.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import UIKit

class BaseController<CoordinatorType: Coordinator, ViewModelType: ViewControllerModel>: UIViewController, Storyboarded, Coordinated, ViewControllerModelDelegate {
    
    typealias T = CoordinatorType
    
    weak var coordinator: T?
    var viewModel: ViewModelType?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWithViewModel()
    }
    
    internal func configureWithViewModel() {
        viewModel?.viewContollerDelegate = self
        title = viewModel?.navigationTitle
    }
    
    internal func toggleLoadingInterface(_ flag: Bool) {
        (navigationController as? MasterNavigationController)?.isLoadingInterfaceRunning = flag
    }
}


