//
//  AccountDetailLoader.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 28.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import Foundation
import IrohaCommunication
import IrohaCrypto

class AccountDetailLoader: NSObject {
    static let shared = AccountDetailLoader()
    
    private var isLoadingFinished = true
    
    private override init() {}
    
    public let userAccountId: IRAccountId = {
        return try! IRAccountIdFactory.account(withIdentifier: UserConfig.userId ?? "")
    }()
    
    public let userSigner: IRSignatureCreatorProtocol = {
        return NSObject.signer(UserConfig.userPrivateKey ?? "")
    }()
    
    @discardableResult
    public func loadAccountDetail(completion: ((Any?) -> (Void))? = nil) -> IRPromise {
        if !isLoadingFinished {
            if let completion = completion {
                completion(nil)
            }
            let error = NSError(domain: "0", code: 0, userInfo: ["messgae": "Previos loadAccountDetail haven't finished execution yet"])
            ErrorsHandler.shared.addError(error)
            return IRPromise(result: error)
        }
        
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: AccountDetailLoader.shared.userAccountId)
                .getAccount(AccountDetailLoader.shared.userAccountId)
                .build()
                .signed(withSignatory: AccountDetailLoader.shared.userSigner, signatoryPublicKey: NSObject.publicKey( UserConfig.userPublicKey ?? "") )
            
            print("Requesting account \(UserConfig.userId ?? "")")
            
            return StreamLiveKeeper.networkService.execute(queryRequest)
                .onThen({ (response) -> IRPromise? in
                    return self.decideOnAccountQuery(response: response)
                }).onThen({ [unowned self] (result) -> IRPromise? in
                    self.isLoadingFinished = true
                    if let result: IRAccountResponse = result as? IRAccountResponse {
                        
                        if let completion = completion {
                            completion(result)
                        }
                        
                        return IRPromise(result: nil)
                    } else {
                        if let completion = completion {
                            completion(nil)
                        }
                        
                        return IRPromise(result: result)
                    }
                })
        } catch {
            ErrorsHandler.shared.addError(error as NSError)
            return IRPromise(result: error as NSError)
        }
    }
    
    private func decideOnAccountQuery(response: Any?) -> IRPromise {
        if let errorResponse = response as? IRErrorResponse {
            if errorResponse.reason == .noAccount {
                asyncPrint("No account \(UserConfig.userId ?? "") found." as AnyObject)
                let error = NSError(domain: "0", code: 0, userInfo: ["message": "No user account found"])
                ErrorsHandler.shared.addError(error)
                return IRPromise(result: error)
                
            } else {
                let error = NSError.error(message: "Error reason code: \(errorResponse.reason), \(errorResponse.message)")
                ErrorsHandler.shared.addError(error)
                return IRPromise(result: error as NSError)
            }
        } else if let _ = response as? IRAccountResponse {
            print("Account \(self.userAccountId.identifier()) exists")
            return IRPromise(result: response)
        } else {
            let error = NSError.error(message: "Unexpected response \(String(describing: response))")
            return IRPromise(result: error as NSError)
        }
    }

}
