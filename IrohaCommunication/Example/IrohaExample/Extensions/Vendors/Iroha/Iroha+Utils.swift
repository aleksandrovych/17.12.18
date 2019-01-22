//
//  Iroha+Utils.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 17.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import IrohaCrypto
import IrohaCommunication

protocol NSObjectIrohaPublic {
    static func signer(_ key: String) -> IRSignatureCreatorProtocol;
    static func privateKey(_ key: String) -> IREd25519PrivateKey;
}

extension NSObject: NSObjectIrohaPublic {
    static func publicKey(_ key: String) -> IREd25519PublicKey {
        let keyData = NSData(hexString: key)! as Data
        return IREd25519PublicKey(rawData: keyData)!
    }
    
    static func privateKey(_ key: String) -> IREd25519PrivateKey  {
        let keyData = NSData(hexString: key)! as Data
        let privateKey = IREd25519PrivateKey(rawData: keyData)!
        return privateKey
    }
    
    static func signer(_ key: String) -> IRSignatureCreatorProtocol {
        let adminPrivateKey = self.privateKey(key)
        return IREd25519Sha512Signer(privateKey: adminPrivateKey)!
    }
    
    static func userAccountId(_ key: String) -> IRAccountId? {
        return try! IRAccountIdFactory.account(withIdentifier: key)
    }
    
    typealias PublicKey = String
    typealias PrivateKey = String
    /* return new pair of public/private key genereted by Ed25519 algorithm */
    func randomKeypair() -> (PublicKey, PrivateKey) {
        let pairFunction = IREd25519KeyFactory().createRandomKeypair() as  IRCryptoKeypairProtocol?
        guard let pair = pairFunction else {
            return ("313a07e6384776ed95447710d15e59148473ccfc052a681317a72a69f2a49910", "f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70")
        }
        
        let pub = pair.publicKey().rawData().map { String(format: "%02x", $0) }.joined()
        let priv = pair.privateKey().rawData().map { String(format: "%02x", $0) }.joined()
        
        return (pub, priv)
    }
}

