//
//  MainCoordinator.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import UIKit

protocol MainDelegate: AnyObject {
    func fetchWeatherData(forCities cities: [String])
    func toggleViewStyle()
    func didUpdate(_ date: Date?)
}

final class MainCoordinator: Coordinator {
    enum ViewStyle {
        case list, grid
        var icon: UIImage? {
            self == .list ? UIImage(systemName: "square.grid.2x2.fill") : UIImage(systemName: "list.dash")
        }
        
        mutating func toggle() {
            self = self == .list ? .grid : .list
        }
    }
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var children = [Coordinator]()
    
    weak var delegate: MainDelegate?
    
    private lazy var navigationDelegate = NavigationDelegate { [unowned self] coord in
        self.childDidFinish(coord)
    }
    
    private let cities = [
        "Tel Aviv",
        "Jerusalem",
        "Eilat",
        "Haifa"
    ]
    
    private var viewStyle: ViewStyle = Defaults.prefersGridUI ? .grid : .list {
        didSet {
            Defaults.prefersGridUI = viewStyle == .grid
        }
    }
    
    private var lastUpdatedAt: Date? = {
        let date = Date(timeIntervalSince1970: Defaults.lastUpdatedAt)
        guard date != Date() else { return nil }
        return date
    }() {
        didSet {
            Defaults.lastUpdatedAt = lastUpdatedAt?.timeIntervalSince1970 ?? 0.0
            delegate?.didUpdate(lastUpdatedAt)
        }
    }
    
    // MARK: - Coordinatin', Coordinator Life Cycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = navigationDelegate
        
        print("Welcome!")
        
        let vc = MainViewController.instantiate()
        vc.coordinator = self
        vc.viewModel = MainViewModel(cachedWeatherItems: try? availableCachedItems(), viewStyle: viewStyle)
        vc.navigationItem.rightBarButtonItems = navigationButtons()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func ready() {
        delegate?.fetchWeatherData(forCities: cities)
    }
    
    func viewStyleDidChanged(_ viewStyle: ViewStyle) {
        self.viewStyle = viewStyle
    }
    
    func didReceiveWeatherItems(_ weatherItems: [WeatherItem]) {
        // Mark the date
        lastUpdatedAt = Date()
        // Remove all existing content
        try? Archiver(.weatherItems).deleteAll()
        // Archive locally.
        do {
            try Archiver(.weatherItems).put(weatherItems)
        } catch {
            print("Failed to archive items: \n \(error)")
        }
    }
    
    func didSelectWeatherItem(_ weatherItem: WeatherItem?) {
        guard let weatherItem = weatherItem else { return }
        
        // Navigate to the city screen.
        startCityCoordinator(with: weatherItem)
    }
    
    // MARK: - Configuration Logic
    
    private func availableCachedItems() throws -> [WeatherItem] {
        try Archiver(.weatherItems).all(WeatherItem.self)?
            .sorted { $0.cityName ?? "" > $1.cityName ?? "" }
            ?? []
    }
    
    private func navigationButtons() -> [UIBarButtonItem] {
        let toggleButton = UIBarButtonItem(image: viewStyle.icon, style: .plain, target: self, action: #selector(toggleViewStyle))
        let refreshButton = UIBarButtonItem(systemItem: .refresh, primaryAction: UIAction { [unowned self] _ in
            self.ready()
        })
        
        return [toggleButton, refreshButton]
    }
    
    @objc private func toggleViewStyle(sender: UIBarButtonItem) {
        delegate?.toggleViewStyle()
        sender.image = viewStyle.icon
    }
}

// MARK: - New-born Coordinators 🎉

extension MainCoordinator {
    func startCityCoordinator(with weatherItem: WeatherItem) {
        let cityCoordinator = CityCoordinator(weatherItem: weatherItem, navigationController: navigationController)
        children.append(cityCoordinator)
        cityCoordinator.start()
    }
}
