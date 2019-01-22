//
//  UIStackView+Utils.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 18.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

protocol UIStackViewUtils {
    @discardableResult
    func addA(_ sub: UIView) -> ConstraintViewDSL
}

extension UIStackView: UIStackViewUtils {
    @discardableResult
    func addA(_ sub: UIView) -> ConstraintViewDSL {
        addArrangedSubview(sub)
        return sub.snp
    }
}
