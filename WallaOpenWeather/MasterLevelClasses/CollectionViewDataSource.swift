//
//  CollectionViewDataSource.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 21/11/2020.
//

import UIKit

final class CollectionViewDataSource<CellType: UICollectionViewCell & Providable>: NSObject, UICollectionViewDataSource {
    
    typealias T = CellType.ProvidedItem
    
    public var data: Binding<[T]> = .init([])
    private var reuseIdentifier: String
    
    init(cellReuseIdentifier: String) {
        self.reuseIdentifier = cellReuseIdentifier
    }
    
    public func update(_ data: [T]) {
        self.data.value = data
    }
    
    public func updateCellIdentifier(_ id: String) {
        self.reuseIdentifier = id
    }
    
    // MARK - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CellType else {
            fatalError("Could not find a Providable Cell with reuse identifier: \(reuseIdentifier)")
        }
        
        cell.provide(data.value[indexPath.item])
        return cell
    }
    
    deinit {
        if Environment.isDebug {
            print("Data Source says: We're out :)")
        }
    }
}
