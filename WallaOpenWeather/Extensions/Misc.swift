//
//  Misc.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

extension Calendar {
    func weekdayNameFrom(weekdayNumber: Int) -> String {
        let calendar = Calendar.current
        let dayIndex = ((weekdayNumber - 1) + (calendar.firstWeekday - 1)) % 7
        return calendar.shortWeekdaySymbols[dayIndex]
    }
}

