#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IRBlockQueryBuilder.h"
#import "IRQueryBuilder.h"
#import "IRTransactionBuilder.h"
#import "NSDate+IrohaCommunication.h"
#import "IRAccountAsset.h"
#import "IRAccountId.h"
#import "IRAddress.h"
#import "IRAmount.h"
#import "IRAssetId.h"
#import "IRDomain.h"
#import "IRGrantablePermission.h"
#import "IRPagination.h"
#import "IRPeerSignature.h"
#import "IRRoleName.h"
#import "IRRolePermission.h"
#import "IRBlockQueryRequest.h"
#import "IRBlockQueryResponse.h"
#import "IRCommand.h"
#import "IRQuery.h"
#import "IRQueryRequest.h"
#import "IRQueryResponse.h"
#import "IRSignable.h"
#import "IRTransaction.h"
#import "IRTransactionStatusResponse.h"
#import "IRPromise.h"
#import "IRNetworkService.h"

FOUNDATION_EXPORT double IrohaCommunicationVersionNumber;
FOUNDATION_EXPORT const unsigned char IrohaCommunicationVersionString[];

