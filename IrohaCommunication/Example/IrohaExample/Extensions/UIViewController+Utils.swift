//
//  UIViewController+Utils.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

protocol UIViewControllerUtils {
    @discardableResult
    func add(_ subview: UIView) -> ConstraintViewDSL
}



extension UIViewController: UIViewControllerUtils {
    @discardableResult
    final func add(_ subview: UIView) -> ConstraintViewDSL {
        view.addSubview(subview);
        return subview.snp;
    }
}


