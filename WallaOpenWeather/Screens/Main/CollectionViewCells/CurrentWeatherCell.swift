//
//  MainCell.swift
//  WallaOpenWeather

//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell, Providable {
    
    typealias ProvidedItem = WeatherItem
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // MARK: - Cell Layout
    
    // MARK: - Properties
    
    private var weatherItem: ProvidedItem! {
        didSet { configure() }
    }
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.applyDefaultDesign()
    }
    
    // MARK: - Configuration
    
    public func provide(_ item: ProvidedItem) {
        self.weatherItem = item
    }
    
    private func configure() {
        backgroundColor = UIColor.tertiarySystemBackground
        conditionImageView.image = UIImage(named: weatherItem.iconName)
        cityLabel.text = weatherItem.cityName
        temperatureLabel.text = weatherItem.formattedTemperature
        humidityLabel?.text = weatherItem.formattedHumidity
    }
    
    // MARK: - Layout
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(layoutAttributes.frame.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: targetSize.width, height: contentView.systemLayoutSizeFitting(CGSize(width: contentView.bounds.width, height: 1)).height)
    }
}
