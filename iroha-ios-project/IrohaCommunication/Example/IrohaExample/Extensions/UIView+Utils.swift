//
//  UIView+Utils.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

protocol UIViewUtils {
    @discardableResult
    func add(_ subview: UIView) -> ConstraintViewDSL
}

extension UIView: UIViewUtils {
    @discardableResult
    final func add(_ subview: UIView) -> ConstraintViewDSL {
        addSubview(subview);
        return subview.snp;
    }
}
