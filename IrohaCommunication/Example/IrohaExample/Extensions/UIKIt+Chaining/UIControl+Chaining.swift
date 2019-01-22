//
//  UIControl+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol UIControlChaining {
    @discardableResult
   func c_addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> UIView;
}

extension UIControl {
    @discardableResult
    func c_addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> UIView {
        addTarget(target, action: action, for: controlEvents)
        return self as UIView
    }
}
