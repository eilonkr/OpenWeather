//
//  UILabel+Extensions.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import UIKit

extension UILabel {
    static func `default`(text: String?, color: UIColor = .label, style: UIFont.TextStyle, alignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.textAlignment = alignment
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}
