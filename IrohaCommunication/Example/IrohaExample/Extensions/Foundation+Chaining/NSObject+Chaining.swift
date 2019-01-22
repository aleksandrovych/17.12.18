//
//  NSObject+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 18.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import Foundation

protocol NSObjectChaining {
    @discardableResult
    func c_addObserver(_ observer: NSObject, forKeyPath keyPath: String) -> NSObject;
}

extension NSObject: NSObjectChaining {
    @discardableResult
    func c_addObserver(_ observer: NSObject, forKeyPath keyPath: String) -> NSObject  {
        addObserver(observer, forKeyPath: keyPath, options: [.new], context: nil)
        return self
    }
}
