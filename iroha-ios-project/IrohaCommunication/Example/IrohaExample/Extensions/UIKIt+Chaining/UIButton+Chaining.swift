//
//  UIButton+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol UIButtonChaining {
    @discardableResult
    func c_setTitle(_ title: String?, for state: UIControl.State) -> UIButton
    func c_setTitleColor(_ color: UIColor, for state: UIControl.State) -> UIButton
}

extension UIButton: UIButtonChaining {
    @discardableResult
    func c_setTitle<T>(_ title: String?, for state: UIControl.State) -> T where T: UIButton {
        setTitle(title, for: state)
        return self as! T
    }
    
    @discardableResult
    func c_setTitleColor<T>(_ color: UIColor, for state: UIControl.State) -> T where T: UIButton {
        setTitleColor(color, for: state)
        return self as! T
    }
    
}
