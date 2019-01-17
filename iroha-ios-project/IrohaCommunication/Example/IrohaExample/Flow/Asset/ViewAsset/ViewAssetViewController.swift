//
//  ViewAssetViewController.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

class ViewAssetViewController: BackViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.logicLayer = ViewAssetLogicLayer()
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
        
        configure(UILabel(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY - 60 - 35);
        }).c_setText("Account Id: ..").c_setTextColor(UIColor.white)
        
        configure(UILabel(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY);
        }).c_setText("Asset Id: ..").c_setTextColor(UIColor.white)
        
        configure(UILabel(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY + 60 + 35);
        }).c_setText("Ammount of assets should be here: ...").c_setTextColor(UIColor.white)
        
        
    }
}
