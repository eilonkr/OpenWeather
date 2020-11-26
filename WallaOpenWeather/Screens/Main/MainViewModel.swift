//
//  MainViewModel.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import UIKit

final class MainViewModel: NSObject, ViewControllerModel {
    typealias ViewStyle = MainCoordinator.ViewStyle
    
    // MARK: - ViewModelController Properties
    
    var navigationTitle: String = "Home"
    weak var viewContollerDelegate: ViewControllerModelDelegate?
    
    // MARK: - Properties
        
    public var selectedWeatherItem: Binding<WeatherItem?> = .init(nil)
    public var lastUpdatedAtString: Binding<String?> = .init(nil)
    
    public private(set) var dataSource: CollectionViewDataSource<CurrentWeatherCell>?
    public private(set) var viewStyle: ViewStyle {
        didSet {
            dataSource?.updateCellIdentifier(cellId)
            collectionViewLayout.value = (viewStyle, generateCollectionViewLayout())
        }
    }
    
    public lazy var collectionViewLayout: Binding<(ViewStyle, UICollectionViewFlowLayout)> = .init((viewStyle, generateCollectionViewLayout()))
        
    /// Just for convenience :) Bridges over the `dataSource.data.value` binding.
    private var weatherItems: [WeatherItem]? {
        get {
            dataSource?.data.value
        } set {
            dataSource?.data.value = newValue ?? []
        }
    }
    
    private var cellId: String { viewStyle == .list ? "ListCell" : "GridCell" }
        
    // MARK: - Initializer
    
    init(cachedWeatherItems: [WeatherItem]?, viewStyle: ViewStyle) {
        self.viewStyle = viewStyle
        super.init()
        
        self.dataSource = CollectionViewDataSource(cellReuseIdentifier: cellId)
        self.weatherItems = cachedWeatherItems
        
        didUpdate(Date(timeIntervalSince1970: Defaults.lastUpdatedAt))
    }
}

// MARK: - MainDelegate

extension MainViewModel: MainDelegate {
    func fetchWeatherData(forCities cities: [String]) {
        viewContollerDelegate?.toggleLoadingInterface(true)
        WeatherNetworkManager.shared.getCurrentWeatherData(forCities: cities) { [weak self] result in
            self?.viewContollerDelegate?.toggleLoadingInterface(false)
            switch result {
                case .success(let weatherItems):
                    self?.weatherItems = weatherItems
                case .failure(let error):
                    self?.viewContollerDelegate?.presentAlert(title: "Error", message: error.localizedDescription, actionTitle: nil, actionHandler: nil)
            }
        }
    }
    
    func toggleViewStyle() {
        self.viewStyle.toggle()
    }
    
    func didUpdate(_ date: Date?) {
        guard let date = date else { return }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        lastUpdatedAtString.value = "Last updated: \(formatter.string(from: date))"
    }
}

// MARK: - UICollectionView Layout Settings

extension MainViewModel {
    func generateCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width * (viewStyle == .list ? 0.9 : 0.42), height: 100)
        layout.minimumInteritemSpacing = 12.0
        layout.minimumLineSpacing = 16.0
        
        let hmargin: CGFloat = viewStyle == .list ? 0.0 : 20.0
        layout.sectionInset = .init(top: 20.0, left: hmargin, bottom: 20.0, right: hmargin)
        return layout
    }
}

// MARK: - UICollectionView Delegate

extension MainViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let weatherItem = weatherItems?[safe: indexPath.item] else { return }
        self.selectedWeatherItem.value = weatherItem
    }
}

