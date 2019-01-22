//
//  LandingViewController.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 15.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

class LandingViewController: UIViewController {
    
    var logicLayer = LandingLogicLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
    view.c_setBackgroundColor(Palette.bluegreen)
        
        func addMarkerBasic(_ marker: ConstraintMaker) {
            marker.width.equalTo(UIScreen.main.bounds.maxX - 20*2);
            marker.height.equalTo(50);
            marker.centerX.equalTo(UIScreen.main.bounds.midX)
        }
        
        let createAccount = configure(UIButton(type: .system), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY - 30 - 35);
        })
        
        let loginAccount = configure(UIButton(type: .system), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY + 30);
        })
        
        
        let targets = [#selector(logicLayer.createAccountCallback), #selector(logicLayer.loginAccountCallback)]
        let buttons = [createAccount, loginAccount]
        let titles = ["Create Account", "Login Account"]
        
        for (button, action) in zip(buttons, targets) {
        (button.c_setCornerRadius(8).c_setBorderWidth(4).c_setBorderColor(Palette.orange) as! UIButton).c_setTitleColor(UIColor.white, for: .normal).c_addTarget(logicLayer, action: action, for: .touchUpInside)
        }
        
        for (button, title) in zip(buttons, titles) {
            button.c_setTitle(title, for: .normal).c_setBackgroundColor(Palette.lemon)
        }
    }
}
