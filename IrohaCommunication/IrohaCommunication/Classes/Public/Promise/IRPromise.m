#import "IRPromise.h"

@interface IRPromise()

@property(strong, nonatomic)IRPromise* _Nullable next;

@property(strong, nonatomic)IRPromiseResultHandler _Nullable resultHandler;

@property(strong, nonatomic)IRPromiseErrorHandler _Nullable errorHandler;

@end

@implementation IRPromise

#pragma mark - Init

+ (instancetype)promise {
    return [[IRPromise alloc] init];
}

+ (instancetype)promiseWithResult:(nullable id)result {
    IRPromise *promise = [self promise];
    [promise fulfillWithResult:result];

    return promise;
}

#pragma mark - IRPromiseProtocol

- (IRPromise* _Nonnull (^)(IRPromiseResultHandler _Nonnull))onThen {
    return ^(IRPromiseResultHandler block) {
        IRPromise* promise = [[IRPromise alloc] init];

        self.resultHandler = block;
        self.errorHandler = nil;

        self.next = promise;

        if (self.isFulfilled) {
            [self triggerResultProcessing];
        }

        return promise;
    };
}

- (IRPromise* _Nonnull (^)(IRPromiseErrorHandler _Nonnull))onError {
    return ^(IRPromiseErrorHandler block) {
        IRPromise* promise = [[IRPromise alloc] init];

        self.resultHandler = nil;
        self.errorHandler = block;
        self.next = promise;

        if (self.isFulfilled) {
            [self triggerResultProcessing];
        }

        return promise;
    };
}

- (void)fulfillWithResult:(id _Nullable)result {
    if (_isFulfilled) {
        return;
    }

    _result = result;
    _isFulfilled = true;

    if (_next) {
        [self triggerResultProcessing];
    }
}

- (void)triggerResultProcessing {
    if (_isProcessed) {
        return;
    }

    if (![_result isKindOfClass:[NSError class]]) {
        if (_resultHandler) {
            _isProcessed = YES;

            IRPromise* resultPromise = _resultHandler(_result);

            if (!resultPromise) {
                return;
            }

            [resultPromise copyHandlersFromPromise:_next];

            if (resultPromise.isFulfilled) {
                [resultPromise triggerResultProcessing];
            }
        }
    } else {
        if (_errorHandler) {
            _isProcessed = YES;

            IRPromise *resultPromise = _errorHandler(_result);

            if (!resultPromise) {
                return;
            }

            [resultPromise copyHandlersFromPromise:_next];

            if (resultPromise.isFulfilled) {
                [self triggerResultProcessing];
            }

        } else if(_next) {
            _isProcessed = YES;

            [_next fulfillWithResult:_result];
        }
    }
}

- (void)copyHandlersFromPromise:(IRPromise*)promise {
    [self setNext:promise.next];
    [self setResultHandler:promise.resultHandler];
    [self setErrorHandler:promise.errorHandler];
}

@end
