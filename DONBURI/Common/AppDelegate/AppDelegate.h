//
//  AppDelegate.h
//  DemoPepper
//
//  Created by OA-Promotion-Center on 2016/07/28.
//  Copyright © 2016 OA-Promotion-Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CancelSocket *_cancelSocket;
}
@property (strong, nonatomic) UIWindow *window;
//@property (assign, nonatomic) BOOL isRunning;
@end
