//
//  LoginAdminLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol LoginLogicLayerPublic {
    func loginAdminAccountCallback();
    func loginUserAccountCallback();
}

class LoginLogicLayer: BackLogicLayer, LoginLogicLayerPublic {
    
    @objc func loginAdminAccountCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: false) {
            root.show(LoginAdminViewController(), sender: self)
        }
    }
    
    @objc func loginUserAccountCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: false) {
           root.show(LoginUserViewController(), sender: self)
        }
    }
}
