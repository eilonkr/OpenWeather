//
//  MainViewController.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import UIKit


class MainViewController: BaseController<MainCoordinator, MainViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.delegate = viewModel
        coordinator?.ready()
    }
    
    // MARK: - Configuration
    
    override func configureWithViewModel() {
        super.configureWithViewModel()
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel?.dataSource
        configureBindings()
    }
    
    private func configureBindings() {
        viewModel?.dataSource?.data.bind { [unowned self] items in
            collectionView.reloadData()
            coordinator?.didReceiveWeatherItems(items)
        }
        
        viewModel?.collectionViewLayout.bind { [unowned self] (viewStyle, layout) in
            collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.reloadData()
            coordinator?.viewStyleDidChanged(viewStyle)
        }
        
        viewModel?.selectedWeatherItem.bind { [unowned self] item in
            coordinator?.didSelectWeatherItem(item)
        }
        
        viewModel?.lastUpdatedAtString.bind { [unowned self] str in
            lastUpdatedLabel.text = str
        }
    }
}

