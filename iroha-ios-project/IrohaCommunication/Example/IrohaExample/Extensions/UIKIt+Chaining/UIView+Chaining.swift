//
//  UIView+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol UIViewChaining {
    @discardableResult
    func c_setBackgroundColor(_ color: UIColor) -> UIView;
}

protocol UIViewLayerChaining {
    @discardableResult
    func c_setBorderColor(_ color: UIColor) -> UIView;
    
    @discardableResult
    func c_setBorderWidth<T>(_ width: Float) -> T where T: UIView;
    
    @discardableResult
    func c_setCornerRadius<T>(_ radius: Float) -> T where T: UIView;
}

extension UIView: UIViewChaining {
    @discardableResult
    func c_setBackgroundColor<T>(_ color: UIColor) -> T where T: UIView {
        backgroundColor = color;
        return self as! T
    }
}

extension UIView: UIViewLayerChaining {
    @discardableResult
    func c_setBorderColor<T>(_ color: UIColor) -> T where T: UIView {
        layer.borderColor = color.cgColor;
        return self as! T
    }
    
    @discardableResult
    func c_setBorderWidth<T>(_ width: Float) -> T where T: UIView {
        layer.borderWidth = CGFloat(width);
        return self as! T
    }
    
    @discardableResult
    func c_setCornerRadius<T>(_ radius: Float) -> T where T: UIView {
        layer.cornerRadius = CGFloat(radius);
        return self as! T
    }
}
