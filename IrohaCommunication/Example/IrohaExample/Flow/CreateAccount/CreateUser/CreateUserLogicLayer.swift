//
//  CreateUserLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol CreateUserLogicLayerPublic {
    func saveCallback();
}

class CreateUserLogicLayer: BackLogicLayer, CreateUserLogicLayerPublic {
     override func backCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveCallback() {
        
    }
}
