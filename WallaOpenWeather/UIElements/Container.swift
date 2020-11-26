//
//  Container.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 20/11/2020.
//

import UIKit

final class Container: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        configureDesign()
    }
    
    private func configureDesign() {
        layer.applyDefaultDesign()
    }
}
