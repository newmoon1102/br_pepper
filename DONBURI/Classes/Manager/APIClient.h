//
//  APIClient.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "ResponseObject.h"

typedef  void (^ApiCompletion)(ResponseObject *obj);

@interface APIClient : NSObject
@property (strong, nonatomic) NSURL *baseURL;
+ (APIClient *)sharedClient;
+ (void)destroySharedClient;

+ (NSString *)errorCodeMessageWithCode:(NSInteger)status;

#pragma mark - public api
- (void)login:(NSString *)userID password:(NSString *)pwID completion:(ApiCompletion)block;

#pragma mark - get data
- (void)checkUpdatedStatusQuestionDb:(NSString *)token completion:(ApiCompletion)block;
- (void)checkUpdatedStatusOrganizationDb:(NSString *)token completion:(ApiCompletion)block;
- (void)requestUpdateQuestionDb:(NSString *)token completion:(ApiCompletion)block;
- (void)requestUpdateOrganizationDb:(NSString *)token completion:(ApiCompletion)block;

- (void)sendConsultationResultsToAWS:(NSString *)token jsonData:(NSArray *)data completion:(ApiCompletion)block;
@end
