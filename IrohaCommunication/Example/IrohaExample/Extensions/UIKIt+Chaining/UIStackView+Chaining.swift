//
//  UIStackView+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 18.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol UIStackViewChaining {
    @discardableResult
    func c_setSpacing(_ space: CGFloat) -> UIStackView;
    
    @discardableResult
    func c_setAxis(_ ax: NSLayoutConstraint.Axis) -> UIStackView;
    
    @discardableResult
    func c_setAligment(_ al: UIStackView.Alignment) -> UIStackView;
}

extension UIStackView: UIStackViewChaining {
    @discardableResult
    func c_setSpacing(_ space: CGFloat) -> UIStackView {
        spacing = space
        return self
    }
    
    @discardableResult
    func c_setAxis(_ ax: NSLayoutConstraint.Axis) -> UIStackView {
        axis = ax
        return self
    }
    
    @discardableResult
    func c_setAligment(_ al: UIStackView.Alignment) -> UIStackView {
        alignment = al
    return self
    }
}
