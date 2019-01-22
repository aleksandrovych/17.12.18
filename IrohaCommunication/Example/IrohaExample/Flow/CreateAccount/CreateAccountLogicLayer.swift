//
//  CreateAccountLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import IrohaCommunication
import IrohaCrypto

protocol CreateAccountLogicLayerPublic {
    func createAdminAccountCallback();
    func createUserAccountCallback();
}

class CreateAccountLogicLayer: BackLogicLayer, CreateAccountLogicLayerPublic {
        
    override init() {
        super.init()
        DispatchQueue.global().async {
            StreamLiveKeeper.shared.startStream { /* called after first(create account) transaction */ }
        }
    }
    
    override func backCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: true, completion: nil)
    }
    
    @objc func createAdminAccountCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: false) {
            root.show(CreateAdminViewController(), sender: self)
        }
    }
    
    @objc func createUserAccountCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: false) {
            root.show(CreateUserViewController(), sender: self)
        }
    }
    
    
}
