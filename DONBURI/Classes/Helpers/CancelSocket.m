//
//  CancelSocket.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/10/18.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "CancelSocket.h"

@interface CancelSocket ()
@property (atomic, assign, readwrite) BOOL isCancelled;
@end

@implementation CancelSocket

+ (instancetype)cancelSocket
{
    return [[[self class] alloc] init];
}

- (void)cancel
{
    self.isCancelled = YES;
}

@end
