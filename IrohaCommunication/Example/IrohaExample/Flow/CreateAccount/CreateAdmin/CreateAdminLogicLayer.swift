//
//  CreateAdminLogicLayer.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol CreateAdminLogicLayerPublic {
    func saveCallback();
}

class CreateAdminLogicLayer: BackLogicLayer, CreateAdminLogicLayerPublic {
    
    lazy var creator = AccountCreator()
    
    @objc dynamic var isNameValid: Bool = true
    var accountName: String = "" {
        didSet {
            isNameValid = isValidName(input: accountName)
        }
    }
    
    @objc dynamic var isDomainValid: Bool = true
    var domainName: String = "" {
        didSet {
            isDomainValid = isValidName(input: domainName)
        }
    }
    
    /* Account of another manager, that should accept you request and give you manager permisions */
    @objc dynamic var isManagerAccountIdValid: Bool = false
    var managerAccountId: String = "" {
        didSet {
            isManagerAccountIdValid = isValidId(input: managerAccountId)
        }
    }
    
    func isValidName(input: String) -> Bool {
        let RegEx = "[a-z_0-9]{1,32}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: input)
    }
    
    func isValidId(input: String) -> Bool {
        let RegEx = "[a-z_0-9]{1,32}\\@([a-zA-Z]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)*[a-zA-Z]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: input)
    }
    
    override func backCallback() {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        root.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveCallback() {
        creator.createAccount(with: "\(accountName)@\(domainName)".lowercased())
    }
}
