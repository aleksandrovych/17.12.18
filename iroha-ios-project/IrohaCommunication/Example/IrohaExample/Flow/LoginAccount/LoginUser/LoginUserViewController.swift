//
//  LoginUserViewController.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

class LoginUserViewController: BackViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.logicLayer = LoginUserLogicLayer()
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
        
        configure(UITextField(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY - 60 - 35);
        }).c_setBorderStyle(.line).c_setTextAlignment(.center).c_setPlaceholderText("Enter username").c_setBorderColor(Palette.orange).c_setBorderWidth(4).c_setBackgroundColor(Palette.lemon)
        
        configure(UITextField(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY);
        }).c_setBorderStyle(.line).c_setTextAlignment(.center).c_setPlaceholderText("Enter password").c_setBorderColor(Palette.orange).c_setBorderWidth(4).c_setBackgroundColor(Palette.lemon)
        
        (configure(UIButton(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY + (60 + 35));
        }).c_setTitle("Login", for: .normal).c_setBackgroundColor(Palette.lemon).c_setBorderWidth(4).c_setBorderColor(Palette.orange) as UIButton).c_addTarget(logicLayer, action: #selector((logicLayer as! LoginUserLogicLayer).loginCallback), for: .touchUpInside)
        
    }
}
