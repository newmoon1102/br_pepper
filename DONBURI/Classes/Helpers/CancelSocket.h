//
//  CancelSocket.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/10/18.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelSocket : NSObject
@property (atomic, assign, readonly) BOOL isCancelled;

+ (instancetype)cancelSocket;

- (void)cancel;
@end
