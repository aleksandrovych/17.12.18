//
//  IRSignatureVerifier.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import "IRSignatureVerifier.h"
#import "ed25519.h"

@implementation IREd25519Sha512Verifier

- (BOOL)verify:(id<IRSignatureProtocol> _Nonnull)signature forOriginalData:(NSData *)originalData
usingPublicKey:(id<IRPublicKeyProtocol> _Nonnull)publicKey {
    signature_t signature_bytes;
    memcpy(signature_bytes.data, signature.rawData.bytes, ed25519_signature_SIZE);

    public_key_t public_key;
    memcpy(public_key.data, publicKey.rawData.bytes, ed25519_pubkey_SIZE);

    BOOL result = ed25519_verify(&signature_bytes,
                                 originalData.bytes,
                                 originalData.length,
                                 &public_key);

    return result;
}

@end
