//
//  UITableViewCell+Extensions.swift
//  List Examination
//
//  Created by Farras on 06/07/24.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: type(of: self))
    }
}
