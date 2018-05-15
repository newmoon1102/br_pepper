//
//  ApproachVC.m
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "ApproachVC.h"

@interface ApproachVC ()
@property (nonatomic, strong) AudioPlayerManager *auPlayer;
@end

@implementation ApproachVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.auPlayer = [[AudioPlayerManager alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isEnableSound){
        NSInteger soundId = [[Util objectForKey:kUserAlarmIdDetectPeople] integerValue];
        T_Sound *sound = [[DataManager sharedInstance] getSoundWithId:soundId];
        if (sound) {
            NSString *audioPathAtResource = [FileUtil pathOfFile:sound.url withPathType:PathTypeResource];
            if (sound.url != nil && ![sound.url isEqualToString:@""]) {
                if ([FileUtil fileExistsAtPath:audioPathAtResource]) {
                    [self.auPlayer playAudioMenuNoLoop:sound.url inPathType:PathTypeResource];
                }
            }
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isEnableSound = NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.auPlayer isPlaying]) {
        [self.auPlayer stopPlay];
    }
}
- (IBAction)btnSetupClick:(id)sender {
    if ([self.auPlayer isPlaying]) {
        [self.auPlayer stopPlay];
    }
    [Util setObject:@(approach_vc) forKey:kUserInfoCurrentViewAtPepper];
    SettingVC *settingVC = [[SettingVC alloc] initWithNibName:kNibSettingVC bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = settingVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
