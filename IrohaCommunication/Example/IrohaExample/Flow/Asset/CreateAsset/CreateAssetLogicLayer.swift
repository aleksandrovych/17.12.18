//
//  CreateAssetLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol CreateAssetLogicLayerPublic {
    func saveCallback();
}

class CreateAssetLogicLayer: BackLogicLayer, CreateAssetLogicLayerPublic {
    override func backCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: false) {
            root.show(AddAssetViewController(), sender: self)
        }
    }
}
