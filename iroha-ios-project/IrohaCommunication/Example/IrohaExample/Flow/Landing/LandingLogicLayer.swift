//
//  LandingLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol LandingLogicLayerPublic {
    func createAccountCallback();
    func loginAccountCallback();
}

class LandingLogicLayer: NSObject, LandingLogicLayerPublic {
    @objc func createAccountCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.show(CreateAccountViewController(), sender: self)
    }
    
    @objc func loginAccountCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.show(LoginViewController(), sender: self)
    }
}
