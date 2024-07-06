//
//  UICollectionViewCell+Extensions.swift
//  List Examination
//
//  Created by Farras on 07/07/24.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: type(of: self))
    }
}
