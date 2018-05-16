//
//  ErrorView.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "ErrorView.h"

@implementation ErrorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnReConnectClick:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(reConnectAWSserver:)]) {
        [self.delegate reConnectAWSserver:self.currentApi];
    }
}
@end
