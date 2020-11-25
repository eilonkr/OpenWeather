//
//  CityViewmodel.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 20/11/2020.
//

import UIKit

class CityViewModel: ViewControllerModel {
    var navigationTitle: String
    weak var viewContollerDelegate: ViewControllerModelDelegate?
    
    private var currentWeather: WeatherItem
    
    // Bindings
    public lazy var weatherItem: Binding<WeatherItem> = .init(currentWeather)
    
    public private(set) var dataSource: CollectionViewDataSource<DayCell>
    
    init(weatherItem: WeatherItem) {
        navigationTitle = weatherItem.cityName!
        currentWeather = weatherItem
        dataSource = CollectionViewDataSource(cellReuseIdentifier: "DayCell")
    }
}

extension CityViewModel: CityDelegate {
    func fetchForecast() {
        viewContollerDelegate?.toggleLoadingInterface(true)
        WeatherNetworkManager.shared.getFiveDayForecast(forCity: currentWeather.cityName!) { [weak self] result in
            guard let self = self else { return }
            self.viewContollerDelegate?.toggleLoadingInterface(false)
            switch result {
                case .success(let items):
                    self.dataSource.update(items)
                case .failure(let error):
                    print(error)
                    self.viewContollerDelegate?.presentAlert(title: "Error", message: error.localizedDescription, actionTitle: nil, actionHandler: nil)
            }
        }
    }
}
