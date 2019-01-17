//
//  NSObject+Utils.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

protocol NSObjectUtils {
    @discardableResult
    func configure(_ view: UIView, at superview: UIView, constraints closure: (ConstraintMaker) -> Void) -> UIView;
}

extension NSObject: NSObjectUtils {
    @discardableResult
    func configure<T>(_ view: T, at superview: UIView,constraints closure: (ConstraintMaker) -> Void) -> T where T: UIView {
        superview.add(view).m(closure)
        return view
    }
}
