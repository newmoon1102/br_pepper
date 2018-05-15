//
//  WaitingVC.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/15.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "WaitingVC.h"

@interface WaitingVC ()
@property (nonatomic, strong) AudioPlayerManager *auPlayer;
@end

@implementation WaitingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self setTitle:@"Pepper待機中です"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSetupClick:(id)sender {
    if ([self.auPlayer isPlaying]) {
        [self.auPlayer stopPlay];
    }
    [Util setObject:@(waiting_vc) forKey:kUserInfoCurrentViewAtPepper];
    SettingVC *settingVC = [[SettingVC alloc] initWithNibName:kNibSettingVC bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = settingVC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
