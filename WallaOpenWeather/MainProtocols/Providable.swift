//
//  Providable.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 21/11/2020.
//

import Foundation

protocol Providable {
    associatedtype ProvidedItem
    func provide(_ item: ProvidedItem)
}
