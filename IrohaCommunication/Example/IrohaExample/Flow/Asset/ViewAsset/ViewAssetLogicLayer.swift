//
//  ViewAssetLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import IrohaCommunication

protocol ViewAssetLogicLayerPublic {
    func addCallback();
    func createCallback();
    func refreshCallback();
}

class ViewAssetLogicLayer: BackLogicLayer, ViewAssetLogicLayerPublic {
    
    @objc dynamic var isDataLoaded = true
    @objc dynamic var isAdmin = false
    @objc dynamic var accountId = ""
    @objc dynamic var details = ""
    
    override init() {
        super.init()
        AccountCreator.shared.c_addObserver(self, forKeyPath: #keyPath(AccountCreator.isAccountCreateTransactionSended))
    }
    
    deinit {
        AccountCreator.shared.removeObserver(self, forKeyPath: #keyPath(AccountCreator.isAccountCreateTransactionSended));
        
    }
    
    @objc func addCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: false) {
            root.show(AddAssetViewController(), sender: self)
        }
    }
    
    @objc func createCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: false) {
            root.show(CreateAssetViewController(), sender: self)
        }
    }
    
    @objc func refreshCallback() {
        loadData()
    }
    
    private func loadData() {
        DispatchQueue.main.async {
            self.isDataLoaded = true
        }
        
        AccountDetailLoader.shared.loadAccountDetail { [unowned self] result in
            self.isDataLoaded = false
            if let result: IRAccountResponse = result as? IRAccountResponse {
                for role in result.roles {
                    if role.value == InteractionWithAdminBot.Constants.adminRole {
                        self.isAdmin = true
                    }
                }
                
                self.accountId = result.accountId.identifier()
                self.details = result.details ?? ""
            }
        }
    }
    
    override func backCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(AccountCreator.isAccountCreateTransactionSended) {
            if (object as! AccountCreator).isAccountCreateTransactionSended {
                // TODO - Cancel request if account not already created
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(10)) {
                    self.loadData()
                }
            }
            
            
            
        }
    }
    
}
