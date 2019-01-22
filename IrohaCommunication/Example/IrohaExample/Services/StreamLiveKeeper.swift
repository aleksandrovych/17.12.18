//
//  StreamService.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 17.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import IrohaCommunication
import IrohaCrypto

protocol StreamLiveKeeperPublic {
    func startStream(with completion: (() -> (Void))?)
}

class StreamLiveKeeper: NSObject, StreamLiveKeeperPublic {
    
    static let shared = StreamLiveKeeper()
    
    func startStream(with completion: (() -> (Void))?) {
        do {
            self.onStart = completion
            try startCommitStream()
        } catch {
            ErrorsHandler.shared.addError(error as NSError)
        }
    }
    
    public struct Accounts {
        static let unauthorizedAccountId = "admin@test";
        static let unauthorizedAccountPublicKey = "313a07e6384776ed95447710d15e59148473ccfc052a681317a72a69f2a49910"; // admin.pub
        static let unauthorizedAccountPrivateKey =
            //
        "f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70"; // admin.priv
    }
    
    private struct URLs {
        static let irohaIp = "127.0.0.1";
        static let irohaPort = "50051";
    }
    
    private override init() {
        super.init()
    }
    
    private var onStart: (() -> (Void))? = nil
    
    static let networkService: IRNetworkService = {
        let irohaAddress = try! IRAddressFactory.address(withIp: URLs.irohaIp, port: URLs.irohaPort)
        return IRNetworkService(address: irohaAddress)
    }()
    
    static let unauthorizedSigner: IRSignatureCreatorProtocol = {
        return NSObject.signer(Accounts.unauthorizedAccountPrivateKey)
    }()
    
    static public let unauthorizedAccountId: IRAccountId = {
        return try! IRAccountIdFactory.account(withIdentifier: Accounts.unauthorizedAccountId)
    }()
    
    private func startCommitStream() throws {
        let commitsRequest = try IRBlockQueryBuilder(creatorAccountId: StreamLiveKeeper.unauthorizedAccountId)
            .build()
            .signed(withSignatory: StreamLiveKeeper.unauthorizedSigner, signatoryPublicKey: NSObject.publicKey(Accounts.unauthorizedAccountPublicKey))
        
        StreamLiveKeeper.networkService.streamCommits(commitsRequest) { /*[unowned self]*/ (optionalResponse, done, optionalError) in
            if let response = optionalResponse {
                guard let block = response.block else {
                    ErrorsHandler.shared.addError(response.error! as NSError)
                    return
                }
                
                print("Did receive commit at height=\(block.height), numOfTransactions=\(block.transactions.count)")
            } else if let error = optionalError {
                ErrorsHandler.shared.addError(error as NSError)
            }
            
            if done {
                if let onStart = self.onStart {
                    onStart()
                }
            }
        }
    }
}

