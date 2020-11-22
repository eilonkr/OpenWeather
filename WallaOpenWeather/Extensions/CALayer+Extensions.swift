//
//  CALayer+Extensions.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import UIKit

extension CALayer {
    enum CornerRadiusStyle {
        case `default`
        case round
        case custom(CGFloat)
    }
    
    func roundCorners(to radiusStyle: CornerRadiusStyle) {
        switch radiusStyle {
            case .default:
                cornerRadius = 10.0
            case .round:
                cornerRadius = bounds.height / 2
            case .custom(let c):
                cornerRadius = c
        }
    }
    
    func applyShadow(radius: CGFloat = 8.0, opacity: Float = 1) {
        shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        shadowOpacity = opacity
        shadowRadius = radius
        shadowOffset = CGSize(width: 0, height: 3.0)
    }
    
    func applyDefaultDesign() {
        masksToBounds = false
        roundCorners(to: .default)
        applyShadow()
    }
}


