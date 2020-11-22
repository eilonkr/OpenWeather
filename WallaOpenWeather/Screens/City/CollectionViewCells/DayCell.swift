//
//  DayView.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 20/11/2020.
//

import UIKit

class DayCell: UICollectionViewCell, Providable {
    
    typealias ProvidedItem = WeatherItem
    
    private var iconImageView: UIImageView!
    private var tempLabel: UILabel!
    private var dayLabel: UILabel!

    private var weatherItem: ProvidedItem! {
        didSet { configure() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyDesign()
    }
    
    public func provide(_ item: ProvidedItem) {
        self.weatherItem = item
    }
    
    // MARK: - Configuration
    
    private func initialSetup() {
        iconImageView = UIImageView(image: UIImage())
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.applyShadow()
        tempLabel = UILabel.default(text: nil, style: .title2, alignment: .center)
        dayLabel = UILabel.default(text: nil, color: .secondaryLabel, style: .caption1, alignment: .center)
        let stack = UIStackView(arrangedSubviews: [iconImageView, tempLabel, dayLabel])
        stack.axis = .vertical
        stack.spacing = 8.0
        stack.alignment = .fill
        stack.fix(in: contentView, padding: .even(8.0))
    }
    
    private func configure() {
        iconImageView.image = UIImage(named: weatherItem.iconName)
        tempLabel.text = weatherItem.formattedShortTemperature
        dayLabel.text = weatherItem.dayStringFromDate
    }
    
    private func applyDesign() {
        backgroundColor = .quaternarySystemFill
        layer.roundCorners(to: .default)
    }
    
    // MARK: - Layout
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        layoutAttributes.frame.size = systemLayoutSizeFitting(layoutAttributes.frame.size, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
        return layoutAttributes
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize(width: contentView.systemLayoutSizeFitting(CGSize(width: 1, height: contentView.bounds.height)).width, height: targetSize.height)
    }
    
    // MARK: - Abondoned initializers :(
    
    required init?(coder: NSCoder) {
        fatalError("pls don't")
    }
}
