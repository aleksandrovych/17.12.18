//
//  NSObject+Logs.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import Foundation

protocol NSObjectLoggable {
    func asyncPrint(_ object: AnyObject);
}

extension NSObject: NSObjectLoggable {
    func asyncPrint(_ object: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            print(object)
        }
    }
}
