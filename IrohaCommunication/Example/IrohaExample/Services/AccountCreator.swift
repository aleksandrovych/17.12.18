//
//  AccountCreator.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 18.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import IrohaCrypto
import IrohaCommunication

class AccountCreator: NSObject {
    
    public func createAccount(with id: String) {
        do {
            let keypair = self.createKey()
            try createAccountIfNeeded(keypair, id: id)
        } catch {
            ErrorsHandler.shared.addError(error as NSError)
        }
    }
    
    typealias PublicKey = String;
    typealias PrivateKey = String;
    private func createKey() -> (PublicKey, PrivateKey) {
        let keyPair = self.randomKeypair()
        return keyPair
    }
    
    @discardableResult
    private func createAccountIfNeeded(_ keypair: (PublicKey, PrivateKey), id: String) throws -> IRPromise {
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: StreamLiveKeeper.unauthorizedAccountId)
                .getAccount(NSObject.userAccountId(id)!)
                .build()
                .signed(withSignatory: StreamLiveKeeper.unauthorizedSigner, signatoryPublicKey: NSObject.publicKey(StreamLiveKeeper.Accounts.unauthorizedAccountPublicKey) )
            
            asyncPrint("Requesting account \(id)" as AnyObject)
            
            return StreamLiveKeeper.networkService.execute(queryRequest)
                .onThen({ (response) -> IRPromise? in
                    return self.decideOnAccountQuery(response: response, keyPair: keypair, id: id)
                }).onThen({ [unowned self] (result) -> IRPromise? in
                    if let sentTransactionHash = result as? Data {
                        self.asyncPrint("Transaction has been sent \((sentTransactionHash as NSData).toHexString())" as AnyObject)
                        return StreamLiveKeeper.networkService.onTransactionStatus(.committed, withHash: sentTransactionHash)
                    } else {
                        return IRPromise(result: result)
                    }
                })
        } catch {
            return IRPromise(result: error as NSError)
        }
    }
    
    private func decideOnAccountQuery(response: Any?, keyPair: (PublicKey, PrivateKey), id: String) -> IRPromise {
        if let errorResponse = response as? IRErrorResponse {
            if errorResponse.reason == .noAccount {
                ErrorsHandler.shared.addError(NSError(domain: "0", code: 0, userInfo: ["message": "No account \(id) found. Creating new one..."]))
                do {
                    let transaction = try IRTransactionBuilder(creatorAccountId: StreamLiveKeeper.unauthorizedAccountId)
                        .createAccount(NSObject.userAccountId(id)!, publicKey: NSObject.publicKey(keyPair.0))
                        .build()
                        .signed(withSignatories: [StreamLiveKeeper.unauthorizedSigner], signatoryPublicKeys: [NSObject.publicKey(StreamLiveKeeper.Accounts.unauthorizedAccountPublicKey)])
                    
                    return StreamLiveKeeper.networkService.execute(transaction)
                } catch {
                    return IRPromise(result: error as NSError)
                }
                
            } else {
                let error = NSError.error(message: "Error reason code: \(errorResponse.reason), \(errorResponse.message)")
                ErrorsHandler.shared.addError(error)
                return IRPromise(result: error as NSError)
            }
        } else if let _ = response as? IRAccountResponse {
            asyncPrint("Account \(id) already exists" as AnyObject)
            return IRPromise(result: nil)
        } else {
            let error = NSError.error(message: "Unexpected response \(String(describing: response))")
            ErrorsHandler.shared.addError(error)
            return IRPromise(result: error as NSError)
        }
    }
}
