#import "IRNetworkService.h"
#import "Endpoint.pbrpc.h"
#import "Queries.pbobjc.h"
#import "IRTransactionImpl.h"
#import "Transaction.pbobjc.h"
#import "IRTransactionStatusResponseImpl+Proto.h"
#import "GRPCCall+Tests.h"
#import "IRQueryResponse+Proto.h"
#import "IRBlockQueryRequestImpl.h"
#import "IRBlockQueryResponse+Proto.h"
#import <IrohaCrypto/NSData+Hex.h>

@interface IRNetworkService()

@property(strong, nonatomic)CommandService_v1 *commandService;
@property(strong, nonatomic)QueryService_v1 *queryService;

@end

@implementation IRNetworkService

#pragma mark - Initialize

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address {
    if (self = [super init]) {
        [GRPCCall useInsecureConnectionsForHost:address.value];

        _commandService = [[CommandService_v1 alloc] initWithHost:address.value];
        _queryService = [[QueryService_v1 alloc] initWithHost:address.value];
    }

    return self;
}

#pragma mark - Transaction

- (nonnull IRPromise *)executeTransaction:(nonnull id<IRTransaction>)transaction {
    IRPromise *promise = [IRPromise promise];

    if (![transaction conformsToProtocol:@protocol(IRProtobufTransformable)]) {
        NSString *message = @"Unsupported transaction implementation";
        NSError *error = [NSError errorWithDomain:NSStringFromClass([IRNetworkService class])
                                             code:IRTransactionErrorSerialization
                                         userInfo:@{NSLocalizedDescriptionKey: message}];

        [promise fulfillWithResult:error];
        return promise;
    }

    NSError *error = nil;
    Transaction *pbTransaction = [(id<IRProtobufTransformable>)transaction transform:&error];

    if (!pbTransaction) {
        [promise fulfillWithResult:error];
        return promise;
    }

    error = nil;
    NSData *transactionHash = [transaction transactionHashWithError:&error];
    if (!transaction) {
        [promise fulfillWithResult:error];
        return promise;
    }

    GRPCProtoCall *call = [_commandService RPCToToriiWithRequest:pbTransaction
                                   handler:^(GPBEmpty * _Nullable response, NSError * _Nullable error) {
                                       if (error) {
                                           [promise fulfillWithResult: error];
                                       } else {
                                           [promise fulfillWithResult:transactionHash];
                                       }
                                   }];
    [call start];

    return promise;
}

- (nonnull IRPromise *)fetchTransactionStatus:(nonnull NSData*)transactionHash {
    TxStatusRequest *statusRequest = [[TxStatusRequest alloc] init];
    statusRequest.txHash = [transactionHash toHexString];

    __weak typeof(self) weakSelf = self;

    IRPromise *promise = [[IRPromise alloc] init];

    IRTransactionStatusBlock handler = ^(id<IRTransactionStatusResponse> response, BOOL done, NSError *error) {
        if (response) {
            [promise fulfillWithResult:response];
        } else {
            [promise fulfillWithResult:error];
        }
    };

    [_commandService statusWithRequest:statusRequest
                               handler:^(ToriiResponse * _Nullable response, NSError * _Nullable error) {
                                   [weakSelf proccessTransactionStatusResponse:response
                                                                         error:error
                                                                          done:YES
                                                                       handler:handler];
                               }];

    return promise;
}

- (nonnull IRPromise *)onTransactionStatus:(IRTransactionStatus)transactionStatus
                                  withHash:(nonnull NSData*)transactionHash {
    TxStatusRequest *statusRequest = [[TxStatusRequest alloc] init];
    statusRequest.txHash = [transactionHash toHexString];

    __block __weak GRPCProtoCall *weakCall = nil;

    IRPromise *promise = [IRPromise promise];

    __block NSMutableArray<NSNumber*> *receivedStatuses = [NSMutableArray array];

    id eventHandler = ^(BOOL done, ToriiResponse *response, NSError *error) {
        if (!weakCall) {
            return;
        }

        if (response) {
            NSError *parsingError;

            id<IRTransactionStatusResponse> statusResponse = [IRTransactionStatusResponse statusResponseWithToriiResponse:response
                                                                                                                    error:&parsingError];

            [receivedStatuses addObject:@(statusResponse.status)];

            if (statusResponse && statusResponse.status == transactionStatus) {
                [promise fulfillWithResult:@(transactionStatus)];

                [weakCall cancel];
                weakCall = nil;
            }
        } else if (done && !promise.isFulfilled) {
            if (error) {
                [promise fulfillWithResult:error];
            } else {
                NSString *message = [NSString stringWithFormat:@"Received statuses [%@], but waited for %@. Streaming closed.",
                                     [receivedStatuses componentsJoinedByString:@","], @(transactionStatus)];
                NSError *networkError = [NSError errorWithDomain:NSStringFromClass([IRNetworkService class])
                                                            code:IRNetworkServiceErrorTransactionStatusNotReceived
                                                        userInfo:@{NSLocalizedDescriptionKey: message}];
                [promise fulfillWithResult:networkError];
            }
        }
    };

    GRPCProtoCall *call = [_commandService RPCToStatusStreamWithRequest:statusRequest
                                                           eventHandler:eventHandler];
    weakCall = call;

    [call start];

    return promise;
}

- (void)streamTransactionStatus:(nonnull NSData*)transactionHash
                      withBlock:(nonnull IRTransactionStatusBlock)block {
    TxStatusRequest *statusRequest = [[TxStatusRequest alloc] init];
    statusRequest.txHash = [transactionHash toHexString];

    __weak typeof(self) weakSelf = self;

    [_commandService statusStreamWithRequest: statusRequest
                                eventHandler:^(BOOL done, ToriiResponse *response, NSError *error) {
                                    [weakSelf proccessTransactionStatusResponse:response
                                                                          error:error
                                                                           done:done
                                                                        handler:block];
    }];
}

#pragma mark - Query

- (nonnull IRPromise*)executeQueryRequest:(nonnull id<IRQueryRequest>)queryRequest {
    IRPromise *promise = [IRPromise promise];

    if (![queryRequest conformsToProtocol:@protocol(IRProtobufTransformable)]) {
        NSString *message = @"Unsupported query implementation";
        NSError *error = [NSError errorWithDomain:NSStringFromClass([IRNetworkService class])
                                             code:IRTransactionErrorSerialization
                                         userInfo:@{NSLocalizedDescriptionKey: message}];

        [promise fulfillWithResult:error];
        return promise;
    }

    NSError *error;
    Query *protobufQuery = [(id<IRProtobufTransformable>)queryRequest transform:&error];

    if (!protobufQuery) {
        [promise fulfillWithResult:error];
        return promise;
    }

    [_queryService findWithRequest:protobufQuery handler:^(QueryResponse* _Nullable response, NSError* _Nullable error) {
        if (response) {
            NSError *parsingError = nil;
            id<IRQueryResponse> queryResponse = [IRQueryResponseProtoFactory responseFromProtobuf:response
                                                                                            error:&parsingError];

            if (queryResponse) {
                [promise fulfillWithResult:queryResponse];
            } else {
                [promise fulfillWithResult:parsingError];
            }
        } else {
            [promise fulfillWithResult:error];
        }
    }];

    return promise;
}

#pragma mark - Commits

- (void)streamCommits:(nonnull id<IRBlockQueryRequest>)request
            withBlock:(nonnull IRCommitStreamBlock)block {
    if (![request conformsToProtocol:@protocol(IRProtobufTransformable)]) {
        NSString *message = @"Unsupported block query request implementation";
        NSError *error = [NSError errorWithDomain:NSStringFromClass([IRNetworkService class])
                                             code:IRQueryRequestErrorSerialization
                                         userInfo:@{NSLocalizedDescriptionKey: message}];
        block(nil, true, error);
        return;
    }

    NSError *pbError = nil;
    BlocksQuery *pbBlockQuery = [(id<IRProtobufTransformable>)request transform:&pbError];

    if (!pbBlockQuery) {
        block(nil, true, pbError);
        return;
    }

    [_queryService fetchCommitsWithRequest:pbBlockQuery
                              eventHandler:^(BOOL done, BlockQueryResponse * _Nullable pbResponse, NSError * _Nullable error) {
                                  if (pbResponse) {
                                      NSError *parsingError = nil;
                                      id<IRBlockQueryResponse> response = [IRBlockQueryResponse responseFromPbResponse:pbResponse
                                                                                                                 error:&parsingError];
                                      block(response, done, parsingError);
                                  } else {
                                      block(nil, done, error);
                                  }
                              }];
}

#pragma mark - Private

- (void)proccessTransactionStatusResponse:(nullable ToriiResponse *)toriiResponse
                                    error:(nullable NSError *)error
                                     done:(BOOL)done
                                  handler:(nonnull IRTransactionStatusBlock)handler {
    if (toriiResponse) {
        NSError *parsingError;
        id<IRTransactionStatusResponse> statusResponse = [IRTransactionStatusResponse statusResponseWithToriiResponse:toriiResponse
                                                                                                                error:&parsingError];

        handler(statusResponse, done, parsingError);
    } else {
        handler(nil, done, error);
    }
}

@end
