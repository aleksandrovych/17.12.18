//
//  ConstraintViewDSL+Utils.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import SnapKit

protocol ConstraintViewDSLUtils {
    @discardableResult
    func m(_ closure: (ConstraintMaker) -> Void) -> UIView;
}

extension ConstraintViewDSL: ConstraintViewDSLUtils {
    @discardableResult
    func m(_ closure: (ConstraintMaker) -> Void) -> UIView {
        makeConstraints(closure);
        guard let view: UIView = target as? UIView else {
            return UIView()
        }
        view.layoutIfNeeded()
        return view
    }
}
