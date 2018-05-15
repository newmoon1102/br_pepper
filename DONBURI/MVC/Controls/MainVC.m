//
//  MainVC.m
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()
@property (nonatomic, strong) AudioPlayerManager *auPlayer;
@property (assign, nonatomic) ErrorView *errView;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerDefaultsFromSetting:^{
        [self loginAwsServer];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loginAwsServer
{
    NSString *awsUserId = [Util objectForKey:kDefaultAwsUserId];
    NSString *awsUserPw = [Util objectForKey:kDefaultAwsUserPw];
    NSString *awsApiAddr = [Util objectForKey:kDefaultAwsApiUrl];
    if ([awsApiAddr isEqualToString:@""] || awsApiAddr == nil) {
        [Util showMessage:kAlertMsgNotFoundAwsApi withTitle:kAlertMsgError];
        return;
    }
    if ([awsUserId isEqualToString:@""]) {
        [Util showMessage:kAlertMsgNotInputUserId withTitle:kAlertMsgError];
    }else if ([awsUserPw isEqualToString:@""]){
        [Util showMessage:kAlertMsgNotInputPassword withTitle:kAlertMsgError];
    }else
    {
        [self loginWithID:awsUserId andPassWord:awsUserPw];
    }
}
- (void)loginWithID:(NSString *)userID andPassWord:(NSString *)userPass{
    __block id copy_self = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = kAlertMsgLogin;
    
    [[APIClient sharedClient] login:userID password:userPass completion:^(ResponseObject *obj) {
        [hud hide:YES];
        if (obj.statusCode == api_ok) {
            NSString *token = [Util validateString:obj.response[@"token"]];
            [Util setObject:token forKey:kUserInfoAwsApiToken];
        }else if(obj.statusCode == api_err_invalid || obj.statusCode == api_err_not_exist ||
                 obj.statusCode == api_err_system || obj.statusCode == api_err_system_mainten || obj.statusCode == api_err_login_info){
            [copy_self processErrorWithPopup:obj.statusCode errComment:obj.message currentApi:api_login];
        }else{
            [copy_self processErrorCode:obj.statusCode errComment:obj.message];
        }
    }];
}

- (IBAction)btnSetupClick:(id)sender {
    if ([self.auPlayer isPlaying]) {
        [self.auPlayer stopPlay];
    }
    [Util setObject:@(main_vc) forKey:kUserInfoCurrentViewAtPepper];
    SettingVC *settingVC = [[SettingVC alloc] initWithNibName:kNibSettingVC bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = settingVC;
}

#pragma mark ----- Process Error -----
- (void)processErrorCode:(NSInteger)code errComment:(NSString *)comment{
    NSString *msg = [APIClient errorCodeMessageWithCode:code];
    if (comment != nil) {
        [Util showMessage:comment withTitle:kAlertMsgError];
    }else if (msg != nil){
        [Util showMessage:msg withTitle:kAlertMsgError];
    }
}
- (void)processErrorWithPopup:(NSInteger)code errComment:(NSString *)comment currentApi:(aws_api_type)currentApi{
    if (self.errView == nil) {
        NSArray *arrErrView = [[NSBundle mainBundle] loadNibNamed:kNibErrorView owner:self options:nil];
        self.errView = [arrErrView objectAtIndex:0];
    }
    self.errView.delegate = self;
    self.errView.currentApi = currentApi;
    self.errView.lbErrorCode.text = [NSString stringWithFormat:@"%ld",(long)code];
    self.errView.lbErrorContent.text = comment;
    if (code == api_err_invalid) {
        self.errView.lbMessage.text = kAlertMsgServerInvalidRequest;
        [self.view addSubview:self.errView];
    }else if (code == api_err_system){
        self.errView.lbMessage.text = kAlertMsgServerSystemError;
        [self.view addSubview:self.errView];
    }else if(code == api_err_system_mainten){
        self.errView.lbMessage.text = kAlertMsgServerMainten;
        [self.view addSubview:self.errView];
    }else{
        [Util showMessage:comment withTitle:kAlertMsgError];
    }
}
#pragma mark ----- Error Delegate ----
- (void)reConnectAWSserver:(aws_api_type)currentApi
{
    [self hideErrorView];
    if (currentApi == api_login) {
        [self loginAwsServer];
    }
}

- (void)hideErrorView
{
    if (self.errView != nil) {
        [self.errView removeFromSuperview];
        self.errView = nil;
    }
}
- (void)registerDefaultsFromSetting:(void(^)(void))complete
{
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    complete();
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
