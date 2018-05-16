//  APIClient.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//
#import "APIClient.h"
#import "ServicesConfig.h"

@implementation APIClient

static APIClient *_sharedClient = nil;

+ (APIClient *)sharedClient {
    NSString *awsApiAddr = [Util objectForKey:kDefaultAwsApiUrl];
    if (_sharedClient == nil) {
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:awsApiAddr]];
    }
    return _sharedClient;
}
+ (void)destroySharedClient {
    _sharedClient = nil;
}

- (id)initWithBaseURL:(NSURL *)url {
	self.baseURL = url;
    return self;
}
+ (NSString *)errorCodeMessageWithCode:(NSInteger)status{
    switch (status) {
        case 1001:
        case -1009:
        case -1004:
        case -1001:
            return K_API_MSG_NOTIFI_1001;
        case -1011:
            return K_API_MSG_NOTIFI_1011;
        case -1002:
            return K_API_MSG_NOTIFI_1002;
            
        default:
            break;
    }
    return nil;
}

// The function paser data when request success and return data in block
- (void)completeRequestOperation:(AFHTTPRequestOperation *)operation
                        withData:(id)responseData
                           error:(NSError *)err
                      completion:(void(^)(ResponseObject *))completion
{
     NSLog(@"--- url: %@",operation.request.URL);
    if(err){
        [self handleRequestError:err completion:completion];
    }else{
        ResponseObject *obj = [[ResponseObject alloc] init];
        if(responseData){
			NSLog(@"----> Response data : %@", responseData);
			id correctData = responseData;
			if([responseData isKindOfClass:[NSDictionary class]]){
				correctData = [NSMutableDictionary dictionary];
				NSArray *keyArray = [responseData allKeys];
				for (NSString *key in keyArray) {
					id obj = [responseData objectForKey:key];
					if([obj isKindOfClass:[NSNull class]])
						obj = @"";
					[correctData setObject:obj forKey:key];
				}
			}
			obj.response = correctData;
			int status = [[correctData objectForKey:kApiStatus] intValue];
			obj.statusCode = status;
        }
        completion(obj);
    }
}

// The function process return object contain error when request fail
- (void)handleRequestError:(NSError *)error completion:(void(^)(ResponseObject *))completion{
	
	NSError *errorPaser = nil;
	id responseErr = [NSJSONSerialization JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:NSJSONReadingMutableContainers error:&errorPaser];
	
    if (completion) {
        ResponseObject *obj = [[ResponseObject alloc] init];
		[obj setStatusCode:[Util validateInt:[responseErr objectForKey:@"status_code"]]];
		[obj setMessage:[responseErr objectForKey:@"comment"]];
        [obj setResponse:nil];
        completion(obj);
    }
}

// The function request with params
- (void)requestWithPostPath:(NSString *)postPath withParams:(NSDictionary *)params completion:(ApiCompletion)block{
	NSString *strJsonData  = [self jsonStringPretty:params];
	NSString *urlString =[NSString stringWithFormat:@"%@%@",self.baseURL, postPath];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody:[strJsonData dataUsingEncoding:NSUTF8StringEncoding]];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
		[self completeRequestOperation:operation withData:responseObject error:nil completion:block];
	} failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
		[self completeRequestOperation:operation withData:nil error:error completion:block];
	}];
	[operation start];
}
- (NSString *)jsonStringPretty:(id)data
{
	NSError* error = nil;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonString;
}

#pragma mark ----- API -----
- (void)login:(NSString *)userID password:(NSString *)pwID completion:(ApiCompletion)block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:kApiUserID];
    [params setObject:pwID forKey:kApiUserPass];
	[self requestWithPostPath:kApiUrlLogin withParams:params completion:block];
}

#pragma mark ----- Get Data -----
- (void)checkUpdatedStatusQuestionDb:(NSString *)token completion:(ApiCompletion)block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:token forKey:kApiUserToken];
    [self requestWithPostPath:kApiUrlInterviewUpdateTime withParams:params completion:block];
}

- (void)checkUpdatedStatusOrganizationDb:(NSString *)token completion:(ApiCompletion)block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:token forKey:kApiUserToken];
    [self requestWithPostPath:kApiUrlSoshikiUpdateTime withParams:params completion:block];
}
- (void)requestUpdateQuestionDb:(NSString *)token completion:(ApiCompletion)block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:token forKey:kApiUserToken];
    [self requestWithPostPath:kApiUrlInterviewData withParams:params completion:block];
}
- (void)requestUpdateOrganizationDb:(NSString *)token completion:(ApiCompletion)block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:token forKey:kApiUserToken];
    [self requestWithPostPath:kApiUrlSoshikiData withParams:params completion:block];
}

- (void)sendConsultationResultsToAWS:(NSString *)token jsonData:(NSArray *)data completion:(ApiCompletion)block
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params setObject:data forKey:JSON_AWS_ANSWER_LIST];
    [self requestWithPostPath:kApiUrlUpdateResult withParams:params completion:block];
	
}

@end
