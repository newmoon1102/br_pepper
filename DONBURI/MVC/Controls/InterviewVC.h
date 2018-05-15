//
//  InterviewVC.h
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterviewVC : BaseVC
@property (assign, nonatomic) NSInteger questionId;
@property (assign, nonatomic) NSInteger answerId;
@property (nonatomic, assign) BOOL isEnableSound;
@end
