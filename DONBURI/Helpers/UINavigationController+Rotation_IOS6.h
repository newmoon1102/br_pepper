//
//  UINavigationController+Rotation_IOS6.h
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/27.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Rotation_IOS6)
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
@end
