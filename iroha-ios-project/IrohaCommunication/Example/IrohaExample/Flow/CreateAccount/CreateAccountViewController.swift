//
//  CreateAccountViewController.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

class CreateAccountViewController: BackViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.logicLayer = CreateAccountLogicLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let createAdmin = configure(UIButton(type: .system), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY - 30 - 35);
        })
        
        let createUser = configure(UIButton(type: .system), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY + 30);
        })
        
        let targets = [#selector((logicLayer as! CreateAccountLogicLayer).createAdminAccountCallback), #selector((logicLayer as! CreateAccountLogicLayer).createUserAccountCallback)]
        let buttons = [createAdmin, createUser]
        let titles = ["Create Admin", "Create User"]
        
        for (button, action) in zip(buttons, targets) {
            (button.c_setCornerRadius(8).c_setBorderWidth(4).c_setBorderColor(Palette.orange) as! UIButton).c_setTitleColor(UIColor.white, for: .normal).c_addTarget(logicLayer, action: action, for: .touchUpInside)
        }
        
        for (button, title) in zip(buttons, titles) {
            button.c_setTitle(title, for: .normal).c_setBackgroundColor(Palette.lemon)
        }
    }
}
