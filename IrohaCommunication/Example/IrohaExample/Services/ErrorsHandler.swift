//
//  ErrorService.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 17.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import Foundation

final class ErrorsHandler: NSObject {
    static internal let shared = ErrorsHandler()

    private override init() {
        
        errors = []
    }
    
    private var errors: [NSError];
    
    func addError(_ error: NSError) {
        errors.append(error)
    }
    
    func deleteError(_ error: NSError) {
        let i = errors.index(of: error)
        
        guard let indx = i else {
            return
        }
        
        let index = errors.startIndex.distance(to: indx)
        errors.remove(at: index)
    }
}
