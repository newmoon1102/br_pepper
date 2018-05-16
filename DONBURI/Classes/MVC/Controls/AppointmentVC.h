//
//  AppointmentVC.h
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentVC : BaseVC
@property (strong, nonatomic) IBOutlet UILabel *lbEmployeeName;
@property (assign, nonatomic) NSInteger bumonId;
@property (assign, nonatomic) NSInteger shainId;
@property (nonatomic, assign) BOOL isEnableSound;
@end
