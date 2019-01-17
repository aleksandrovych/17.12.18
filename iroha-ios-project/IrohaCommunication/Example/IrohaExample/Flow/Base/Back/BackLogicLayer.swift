//
//  BackLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

 @objc protocol BackLogicLayerPublic {
    func backCallback();
}

 class BackLogicLayer: NSObject, BackLogicLayerPublic {
    @objc func backCallback() {}
}
