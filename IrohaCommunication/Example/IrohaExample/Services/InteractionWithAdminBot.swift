//
//  InteractionWithAdminBot.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 22.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import Foundation
import IrohaCommunication
import IrohaCrypto

class InteractionWithAdminBot: NSObject {
    
    static internal let shared = InteractionWithAdminBot()
    
    private override init() {}
    
    public struct Constants {
       static let firstManagerBot = "first_manager_bot@tecsynt";
        static let adminRole = "admin";
        static let key = "petitioner";
    }
    
    public let firstManagerBotAccountId: IRAccountId = {
        return try! IRAccountIdFactory.account(withIdentifier: Constants.firstManagerBot)
    }()
    
    @discardableResult
    public func requestPermisionsIfPosible(sender: String) -> IRPromise {
        do {
            let queryRequest = try IRQueryBuilder(creatorAccountId: StreamLiveKeeper.unauthorizedAccountId)
                .getAccount(NSObject.userAccountId(Constants.firstManagerBot)!)
                .build()
                .signed(withSignatory: StreamLiveKeeper.unauthorizedSigner, signatoryPublicKey: NSObject.publicKey(StreamLiveKeeper.Accounts.unauthorizedAccountPublicKey) )
            
            asyncPrint("Requesting roles for \(Constants.firstManagerBot)" as AnyObject)
            
            return StreamLiveKeeper.networkService.execute(queryRequest)
                .onThen({ (response) -> IRPromise? in
                    return InteractionWithAdminBot.shared.decideOnAccountQuery(response: response, sender: sender)
                }).onThen({ (result) -> IRPromise? in
                    if let sentTransactionHash = result as? Data {
                        print("Add info about account to admin bot \((sentTransactionHash as NSData).toHexString())")
                        return StreamLiveKeeper.networkService.onTransactionStatus(.committed, withHash: sentTransactionHash)
                    } else {
                        return IRPromise(result: result)
                    }
                })
        } catch {
            ErrorsHandler.shared.addError(error as NSError)
            return IRPromise(result: error as NSError)
        }
    }
    
    private func decideOnAccountQuery(response: Any?, sender: String) -> IRPromise {
        if let errorResponse = response as? IRErrorResponse {
            if errorResponse.reason == .noAccount {
                ErrorsHandler.shared.addError(NSError(domain: "0", code: 0, userInfo: ["message": "No bot account \(Constants.firstManagerBot) found. Check for genesis block from 'genesis' branch of this repo, and restart iroha container with this genesis block and keys from this branch"]))
                do {
                    asyncPrint("Manager Bot is admin now" as AnyObject)
                    return IRPromise()
                }
                
            } else {
                let error = NSError.error(message: "Error reason code: \(errorResponse.reason), \(errorResponse.message)")
                ErrorsHandler.shared.addError(error)
                return IRPromise(result: error as NSError)
            }
        } else if let _ = response as? IRAccountResponse {
            if let accountDetail: IRAccountResponse = response as? IRAccountResponse {
                var hasAdminRole = false
                for role in accountDetail.roles {
                    if role.value == Constants.adminRole {
                        asyncPrint("Manager Bot is admin now" as AnyObject)
                        hasAdminRole = true
                    }
                }
                
                if !hasAdminRole {
                    let error = NSError.error(message: "Bot is not admin now, request permissions from real manager account please")
                    ErrorsHandler.shared.addError(error)
                    return IRPromise(result: error)
                }
                
                return InteractionWithAdminBot.shared.setKeyValuePairForFirstBotAccount(senderId: sender)
            }
        } else {
            let error = NSError.error(message: "Unexpected response \(String(describing: response))")
            ErrorsHandler.shared.addError(error)
            return IRPromise(result: error as NSError)
        }
        
        return IRPromise(result: nil)
    }
    
    private func setKeyValuePairForFirstBotAccount(senderId: String) -> IRPromise {
        do {
            let transaction = try IRTransactionBuilder(creatorAccountId: StreamLiveKeeper.unauthorizedAccountId)
                .setAccountDetail(InteractionWithAdminBot.shared.firstManagerBotAccountId, key: Constants.key, value: senderId)
                .build()
                .signed(withSignatories: [StreamLiveKeeper.unauthorizedSigner], signatoryPublicKeys: [NSObject.publicKey(StreamLiveKeeper.Accounts.unauthorizedAccountPublicKey)])
            
            return StreamLiveKeeper.networkService.execute(transaction)
        } catch {
            return IRPromise(result: error as NSError)
        }
    }
}
