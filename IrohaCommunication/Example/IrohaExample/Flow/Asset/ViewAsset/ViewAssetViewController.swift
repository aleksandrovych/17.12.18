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
        self.logicLayer = ViewAssetLogicLayer().c_addObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.isDataLoaded)).c_addObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.isAdmin)).c_addObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.accountId)).c_addObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.details)) as! BackLogicLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.logicLayer.removeObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.isDataLoaded))
        self.logicLayer.removeObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.isAdmin))
        self.logicLayer.removeObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.accountId))
        self.logicLayer.removeObserver(self, forKeyPath: #keyPath(ViewAssetLogicLayer.details))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    var loader: UILabel? = nil
    var addAsset: UIButton? = nil
    var createAsset: UIButton? = nil
    var refresh: UIButton? = nil
    var amount: UILabel? = nil
    var accountId: UILabel? = nil
    
    func setupUI() {
        view.c_setBackgroundColor(Palette.bluegreen)
        
        func addMarkerBasic(_ marker: ConstraintMaker) {
            marker.width.equalTo(UIScreen.main.bounds.maxX - 20*2);
            marker.height.equalTo(50);
            marker.centerX.equalTo(UIScreen.main.bounds.midX)
        }
        
        let refresh = (configure(UIButton(type: .system), at: view, constraints: {make in
            make.width.equalTo(40);
            make.height.equalTo(40);
            make.left.equalTo(20);
            make.top.equalTo(40);
        }).c_setTitle("\u{21ba}", for: .normal).c_addTarget(logicLayer, action: #selector((logicLayer as! ViewAssetLogicLayer).refreshCallback), for: .touchUpInside) as! UIButton).c_setTitleColor(Palette.orange, for: .normal)
        refresh.titleLabel?.c_setFont(UIFont.systemFont(ofSize: 30)).c_setTextAlignment(.center)
        
        accountId =  configure(UILabel(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY - 2*(60 - 35));
        }).c_setText("Account Id: \((logicLayer as! ViewAssetLogicLayer).accountId)").c_setTextColor(UIColor.white)
        
        configure(UILabel(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY - (60 - 35));
        }).c_setText("Asset Id: ..").c_setTextColor(UIColor.white)
        
       amount = configure(UILabel(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY);
        }).c_setText("Ammount of assets: \((logicLayer as! ViewAssetLogicLayer).details)").c_setTextColor(UIColor.white)
        
        addAsset = (configure(UIButton(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY +  (60 + 35));
        }).c_setTitle("Add asset", for: .normal).c_setBackgroundColor(Palette.lemon).c_setBorderWidth(4).c_setBorderColor(Palette.orange) as UIButton).c_addTarget(logicLayer, action: #selector((logicLayer as! ViewAssetLogicLayer).addCallback), for: .touchUpInside).c_setHidden(!(logicLayer as! ViewAssetLogicLayer).isAdmin) as? UIButton
        
        createAsset = (configure(UIButton(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY +  2 * (60 + 35));
        }).c_setTitle("Create asset", for: .normal).c_setBackgroundColor(Palette.lemon).c_setBorderWidth(4).c_setBorderColor(Palette.orange) as UIButton).c_addTarget(logicLayer, action: #selector((logicLayer as! ViewAssetLogicLayer).createCallback), for: .touchUpInside).c_setHidden(!(logicLayer as! ViewAssetLogicLayer).isAdmin) as? UIButton
        
        loader = ((configure(UILabel(), at: view, constraints: { make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY + 3 * (60 + 35));
        }) as UILabel).c_setTextColor(UIColor.white).c_setText("Data loaded...").c_setTextAlignment(.center).c_setHidden(!(logicLayer as! ViewAssetLogicLayer).isDataLoaded) as UILabel)
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(ViewAssetLogicLayer.isDataLoaded) {
            loader?.c_setHidden(!(object as! ViewAssetLogicLayer).isDataLoaded)
        }
        
        if keyPath == #keyPath(ViewAssetLogicLayer.isAdmin) {
            addAsset?.c_setHidden(!(object as! ViewAssetLogicLayer).isAdmin)
            createAsset?.c_setHidden(!(object as! ViewAssetLogicLayer).isAdmin)
        }
        
        if keyPath == #keyPath(ViewAssetLogicLayer.accountId) {
            accountId?.c_setText("AccountId: \((object as! ViewAssetLogicLayer).accountId)")
        }
        
        if keyPath == #keyPath(ViewAssetLogicLayer.details) {
            amount?.c_setText("Ammount of assets: \((object as! ViewAssetLogicLayer).details)")
        }
    }
}
