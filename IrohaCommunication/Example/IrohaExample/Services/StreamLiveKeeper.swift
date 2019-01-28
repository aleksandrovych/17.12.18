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
        static let unauthorizedAccountId = "unauthorized@tecsynt";
        static let unauthorizedAccountPublicKey = "c77de3a26ca96545e1b1fae01b951798f356b4f7d7eeb7f64f1eca216376b6d4";
        static let unauthorizedAccountPrivateKey =
        "0382d5dd3972576b78273a6c896fac4f76c253366757dea2e484e67decf51043";
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

