#import <Foundation/Foundation.h>
#import "IRTransaction.h"
#import "IRQueryRequest.h"
#import "IRTransactionStatusResponse.h"
#import "IRPromise.h"
#import "IRBlockQueryRequest.h"
#import "IRBlockQueryResponse.h"

typedef void (^IRTransactionStatusBlock)(id<IRTransactionStatusResponse> _Nullable response, BOOL done, NSError * _Nullable error);
typedef void (^IRCommitStreamBlock)(id<IRBlockQueryResponse> _Nullable response, BOOL done, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, IRNetworkServiceError) {
    IRNetworkServiceErrorTransactionStatusNotReceived
};

@interface IRNetworkService : NSObject

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address;

- (nonnull IRPromise *)executeTransaction:(nonnull id<IRTransaction>)transaction;

- (nonnull IRPromise *)onTransactionStatus:(IRTransactionStatus)transactionStatus
                                  withHash:(nonnull NSData*)transactionHash;

- (nonnull IRPromise *)fetchTransactionStatus:(nonnull NSData*)transactionHash;

- (void)streamTransactionStatus:(nonnull NSData*)transactionHash
                      withBlock:(nonnull IRTransactionStatusBlock)block;

- (nonnull IRPromise*)executeQueryRequest:(nonnull id<IRQueryRequest>)queryRequest;

- (void)streamCommits:(nonnull id<IRBlockQueryRequest>)request
            withBlock:(nonnull IRCommitStreamBlock)block;

@end
