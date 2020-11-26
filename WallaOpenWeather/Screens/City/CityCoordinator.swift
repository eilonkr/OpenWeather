//
//  CityCoordinator.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 20/11/2020.
//

import UIKit

protocol CityDelegate: AnyObject {
    func fetchForecast()
}

final class CityCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var children = [Coordinator]()
    
    weak var delegate: CityDelegate?
    
    private var weatherItem: WeatherItem
    
    init(weatherItem: WeatherItem, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.weatherItem = weatherItem
    }
    
    func start() {
        let vc = CityViewController.instantiate()
        vc.coordinator = self
        vc.viewModel = CityViewModel(weatherItem: weatherItem)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func ready() {
        delegate?.fetchForecast()
    }
    
    deinit {
        if Environment.isDebug {
            print("CityCoordinator Says: we're done")
        }
    }
}
