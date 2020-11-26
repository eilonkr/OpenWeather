//
//  CityViewController.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 20/11/2020.
//

import UIKit

final class CityViewController: BaseController<CityCoordinator, CityViewModel> {

    @IBOutlet weak var currentWeatherIconView: UIImageView!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var forecastContainer: Container!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.delegate = viewModel
        coordinator?.ready()
    }
    
    override func configureWithViewModel() {
        super.configureWithViewModel()
        configureCollectionView()
        
        // Setup bindings
        viewModel?.weatherItem.bind { [unowned self] item in
            currentWeatherIconView.image = UIImage(named: item.iconName)
            currentCityLabel.text = item.cityName
            currentTemperatureLabel.text = item.formattedTemperature
            currentHumidityLabel.text = item.formattedHumidity
        }
        
        viewModel?.dataSource.data.bind { [unowned self] items in
            self.forecastContainer.isHidden = items.isEmpty
            forecastCollectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        forecastCollectionView.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        forecastCollectionView.dataSource = viewModel?.dataSource
        
        if let layout = forecastCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 100.0, height: collectionViewHeightConstraint.constant - (layout.sectionInset.top + layout.sectionInset.bottom))
        }
    }
}
