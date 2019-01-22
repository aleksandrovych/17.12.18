//
//  CreateAdminViewController.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

class CreateAdminViewController: BackViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.logicLayer = (CreateAdminLogicLayer().c_addObserver(self, forKeyPath: #keyPath(CreateAdminLogicLayer.isNameValid)).c_addObserver(self, forKeyPath: #keyPath(CreateAdminLogicLayer.isDomainValid)).c_addObserver(self, forKeyPath: #keyPath(CreateAdminLogicLayer.isManagerAccountIdValid)) as! BackLogicLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        logicLayer.removeObserver(self, forKeyPath: #keyPath(CreateAdminLogicLayer.isNameValid));
        logicLayer.removeObserver(self, forKeyPath: #keyPath(CreateAdminLogicLayer.isDomainValid));
        
        name!.logicLayer.removeObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.fieldText))
        domain!.logicLayer.removeObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.fieldText))
        permisions!.logicLayer.removeObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.fieldText))
    }
    
    var name: TextStackViewView? = nil
    var domain: TextStackViewView? = nil
    var permisions: TextStackViewView? = nil
    var save: UIButton? = nil
    
    func setupUI() {
        view.c_setBackgroundColor(Palette.bluegreen)
        
        func addMarkerBasic(_ marker: ConstraintMaker) {
            marker.width.equalTo(UIScreen.main.bounds.maxX - 20*2);
            marker.centerX.equalTo(UIScreen.main.bounds.midX)
        }
        
        name = configure(TextStackViewView(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY - 60 - 35);
        })
        name!.field!.c_setBorderStyle(.line).c_setTextAlignment(.center).c_setPlaceholderText("Enter admin name").c_setBorderColor(Palette.orange).c_setBorderWidth(4).c_setBackgroundColor(Palette.lemon)
        
        name!.logicLayer.c_addObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.fieldText))
        
        domain = configure(TextStackViewView(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY);
        })
        domain!.field!.c_setBorderStyle(.line).c_setTextAlignment(.center).c_setPlaceholderText("Enter admin domain").c_setBorderColor(Palette.orange).c_setBorderWidth(4).c_setBackgroundColor(Palette.lemon)
        
        domain!.logicLayer.c_addObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.fieldText))
        
        permisions = configure(TextStackViewView(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY + 60 + 35);
        })
    permisions!.field!.c_setBorderStyle(.line).c_setTextAlignment(.center).c_setPlaceholderText("Request admin permissions from account").c_setBorderColor(Palette.orange).c_setBorderWidth(4).c_setBackgroundColor(Palette.lemon)
        
        permisions!.logicLayer.c_addObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.fieldText))
        
        save = ((configure(UIButton(), at: view, constraints: {make in
            addMarkerBasic(make)
            make.centerY.equalTo(UIScreen.main.bounds.midY + 2 * (60 + 35));
            make.height.equalTo(40);
        }).c_setTitle("Save admin", for: .normal).c_setBackgroundColor(Palette.lemon).c_setBorderWidth(4).c_setBorderColor(Palette.orange) as UIButton).c_addTarget(logicLayer, action: #selector((logicLayer as! CreateAdminLogicLayer).saveCallback), for: .touchUpInside) as! UIButton)
        setSaveActive((logicLayer as! CreateAdminLogicLayer))
        }
    
    
    func setSaveActive(_ obj: CreateAdminLogicLayer) {
        self.save!.c_setUserInteractionEnabled(obj.isNameValid && obj.isDomainValid && obj.isManagerAccountIdValid)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(CreateAdminLogicLayer.isNameValid) {
            self.name!.c_ShowError((object as! CreateAdminLogicLayer).isNameValid)
            setSaveActive((object as! CreateAdminLogicLayer))
            
        } else if keyPath == #keyPath(CreateAdminLogicLayer.isDomainValid) {
            self.domain!.c_ShowError((object as! CreateAdminLogicLayer).isDomainValid)
            setSaveActive((object as! CreateAdminLogicLayer))
        } else if keyPath == #keyPath(CreateAdminLogicLayer.isManagerAccountIdValid) {
            self.permisions!.c_ShowError((object as! CreateAdminLogicLayer).isManagerAccountIdValid)
            setSaveActive((object as! CreateAdminLogicLayer))
        } else if keyPath == #keyPath(TextStackViewLogicLayer.fieldText) {
            let obj = (object as! TextStackViewLogicLayer);
            
            if obj == self.name?.logicLayer {
                self.name?.c_getText(&(logicLayer as! CreateAdminLogicLayer).accountName)
            } else if obj == self.domain?.logicLayer {
                self.domain?.c_getText(&(logicLayer as! CreateAdminLogicLayer).domainName)
            } else if obj == self.permisions?.logicLayer {
                self.permisions?.c_getText(&(logicLayer as! CreateAdminLogicLayer).managerAccountId)
            }
        }
        
    }
}
