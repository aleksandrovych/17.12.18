//
//  UILabel+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol UILabelChaining {
    @discardableResult
    func c_setFont(_ setted: UIFont) -> UILabel;
    @discardableResult
    func c_setTextAlignment(_ aligment: NSTextAlignment) -> UILabel;
    @discardableResult
    func c_setText(_ string: String) -> UILabel;
    @discardableResult
    func c_setTextColor(_ color: UIColor) -> UILabel;
}

extension UILabel: UILabelChaining {
    @discardableResult
    func c_setFont(_ setted: UIFont) -> UILabel {
        font = setted
        return self
    }
    
    @discardableResult
    func c_setTextAlignment(_ aligment: NSTextAlignment) -> UILabel {
        textAlignment = aligment
        return self
    }
    
    @discardableResult
    func c_setText(_ string: String) -> UILabel {
        text = string
        return self
    }
    
    @discardableResult
    func c_setTextColor(_ color: UIColor) -> UILabel {
        textColor = color
        return self
    }
}
