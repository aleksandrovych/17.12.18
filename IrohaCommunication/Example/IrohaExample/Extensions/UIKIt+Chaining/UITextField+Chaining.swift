//
//  UITextField+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol UITextFieldChaining {
    @discardableResult
    func c_setText(_ string: String?) -> UITextField;
    
    @discardableResult
    func c_setBorderStyle(_ style: UITextField.BorderStyle) -> UITextField;
    
    @discardableResult
    func c_setTextAlignment(_ aligment: NSTextAlignment) -> UITextField;
    
    @discardableResult
    func c_setPlaceholderText(_ text: String) -> UITextField;
    
    @discardableResult
    func c_setDelegate(_ object: UITextFieldDelegate) -> UITextField;
}

extension UITextField: UITextFieldChaining {
    @discardableResult
    func c_setText<T>(_ string: String?) -> T where T: UITextField {
        text = string;
        return self as! T
    }
    
    @discardableResult
    func c_setBorderStyle<T>(_ style: UITextField.BorderStyle) -> T where T: UITextField {
        borderStyle = style;
        return self as! T
    }
    
    @discardableResult
    func c_setTextAlignment<T>(_ aligment: NSTextAlignment) -> T where T: UITextField {
        textAlignment = aligment;
        return self as! T
    }
    
    @discardableResult
    func c_setPlaceholderText(_ text: String) -> UITextField {
        placeholder = text
        return self
    }
    
    @discardableResult
    func c_setDelegate(_ object: UITextFieldDelegate) -> UITextField {
        delegate = object
        return self
    }
}
