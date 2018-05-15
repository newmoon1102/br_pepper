//
//  NoAppointmentVC.m
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "NoAppointmentVC.h"

@interface NoAppointmentVC ()
{
    BOOL isAllowTapScreen;
}
@property (nonatomic, strong) AudioPlayerManager *auPlayer;
@end

@implementation NoAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isAllowTapScreen = YES;
    self.auPlayer = [[AudioPlayerManager alloc] init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isEnableSound) {
        NSInteger soundId = [[Util objectForKey:kUserAlarmIdCallNoAppo] integerValue];
        T_Sound *sound = [[DataManager sharedInstance] getSoundWithId:soundId];
        if (sound) {
            NSString *audioPathAtResource = [FileUtil pathOfFile:sound.url withPathType:PathTypeResource];
            if (sound.url != nil && ![sound.url isEqualToString:@""]) {
                if ([FileUtil fileExistsAtPath:audioPathAtResource]) {
                    [self.auPlayer playAudioMenu:sound.url inPathType:PathTypeResource];
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
    if (!isAllowTapScreen) {
        return;
    }
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(enableAllowTapScreen)
                                   userInfo:nil repeats:NO];
    SocketServer *socketServer = [SocketServer sharedSocket];
    NSMutableDictionary *strCode = [NSMutableDictionary dictionary];
    [strCode setObject:@(ss_res_call_ok) forKey:JSON_KEY_STT_CODE];
    NSString *sendStr = [self jsonStringPretty:strCode];
    if(socketServer){
        [socketServer sendData:sendStr];
    }
    isAllowTapScreen = NO;
}
- (void)enableAllowTapScreen{
    isAllowTapScreen = YES;
}
- (IBAction)btnSetupClick:(id)sender {
    if ([self.auPlayer isPlaying]) {
        [self.auPlayer stopPlay];
    }
    [Util setObject:@(no_appointment_vc) forKey:kUserInfoCurrentViewAtPepper];
    SettingVC *settingVC = [[SettingVC alloc] initWithNibName:kNibSettingVC bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = settingVC;
}
- (NSString *)jsonStringPretty:(id)data
{
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
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
