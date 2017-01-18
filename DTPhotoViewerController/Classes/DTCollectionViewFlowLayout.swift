//
//  DTCollectionViewFlowLayout.swift
//  Pods
//
//  Created by Admin on 17/01/2017.
//
//

import UIKit

class DTCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
