//
//  ErrorView.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@protocol ErrorViewDelegate <NSObject>
@required
-(void)reConnectAWSserver:(aws_api_type)currentApi;
@end

@interface ErrorView : UIView
@property (assign, nonatomic) aws_api_type currentApi;
@property (weak, nonatomic) IBOutlet UILabel *lbErrorCode;
@property (weak, nonatomic) IBOutlet UILabel *lbErrorContent;
@property (weak, nonatomic) IBOutlet UITextView *lbMessage;
@property (nonatomic, weak) id<ErrorViewDelegate> delegate;
@end
