//
//  ResponseObject.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicesConfig.h"

@interface ResponseObject : NSObject

@property (nonatomic, strong) id response;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, strong) NSString *message;

@end
