//
//  AppDelegate.m
//  DemoPepper
//
//  Created by OA-Promotion-Center on 2016/07/28.
//  Copyright © 2016 OA-Promotion-Center. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "WaitingVC.h"
#import "ApproachVC.h"
#import "ReceptionVC.h"
#import "InterviewVC.h"
#import "AppointmentVC.h"
#import "NoAppointmentVC.h"
#import "SettingVC.h"
#import "SocketServer.h"
#import <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUFSIZE 8192

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Util setObject:[NSNumber numberWithBool:NO] forKey:kUserInfoBlockForSetup];
    [self registerDefaultsValue];
    // SQLite
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[appName stringByAppendingString:@".sqlite"]];
    
    NSArray *arrAlarm = [[DataManager sharedInstance] getAllAlarmData];
    if ([arrAlarm count] == 0) {
        [[DataManager sharedInstance] initData];
    }

    MainVC *mainVC = [[MainVC alloc] initWithNibName:kNibMainVC bundle:nil];
    self.window.rootViewController = mainVC;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self stopSocketServer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self stopSocketServer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self stopSocketServer];
    
    [self registerDefaultsFromSetting:^{
        // Socket
        NSString *port = [Util objectForKey:kDefaultSocketServerPort];
        if (port == nil || [port isEqualToString:@""]) {
            [Util showMessage:kAlertMsgPleaseSetupSocketPort withTitle:kAlertMsgError];
        }else{
            [self startSocketServer];
            NSLog(@"------------ startSocketServer ------------");
        }
        // End Socket
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    self.isRunning = NO;
    [self stopSocketServer];
}

#pragma mark ----- SOCKET SERVER -----

- (void)startSocketServer
{
    if (_cancelSocket == nil)
    {
        _cancelSocket = [self startExpensiveOperation];
    }
}

- (void)stopSocketServer
{
    if (_cancelSocket != nil)
    {
        NSLog(@"------------ stopSocketServer ------------");
        SocketServer *ss = [SocketServer sharedSocket];
        [ss close];
        [_cancelSocket cancel];
        _cancelSocket = nil;
    }
}

- (CancelSocket *)startExpensiveOperation
{
    CancelSocket *cancelSocket = [CancelSocket cancelSocket];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       while (!cancelSocket.isCancelled)
       {
            [self startSocket];
       }
    });
    
    return cancelSocket;
}

- (void)startSocket{
    char recvBuff[BUFSIZE];
    SocketServer *ss = [SocketServer sharedSocket];
    NSString *recvStr;
    NSMutableDictionary *strCode = [NSMutableDictionary dictionary];
    [strCode setObject:@(stt_ng) forKey:JSON_KEY_STT_CODE];
    NSString *sendStr = [self jsonStringPretty:strCode];
    while(YES){
        NSString *portNum = [Util objectForKey:kDefaultSocketServerPort];
        printf("Server waiting for connections on port: %s\n", [portNum UTF8String]);
        if([ss accept]){
            BOOL isBlockForSetup = [[Util objectForKey:kUserInfoBlockForSetup] boolValue];
            bzero(recvBuff, BUFSIZE);
            recvStr = [ss receiveBytes:recvBuff maxBytes:BUFSIZE];
            NSData *recvData = [recvStr dataUsingEncoding:NSUTF8StringEncoding];
            if(recvData){
                NSError *errorPaser = nil;
                id recvDictionary = [NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableContainers error:&errorPaser];
                NSLog(@"Response from Pepper: %@",recvDictionary);
                if(errorPaser){
                    NSLog(@"Error paser data");
//                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                    [params setObject:@(0) forKey:JSON_KEY_STT_CODE];
                    sendStr = @"";
                }else{
                    NSLog(@"Paser data get from Pepper");
                    int sttCode = [[recvDictionary objectForKey:JSON_KEY_STT_CODE] intValue];
                    switch (sttCode) {
                        case sc_chk_sock:
                        {
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            [params setObject:@(ss_res_chk_sock) forKey:JSON_KEY_STT_CODE];
                            sendStr = [self jsonStringPretty:params];
                        }
                            break;
                        case sc_chk_que:
                        {
                            sendStr = [self strResponseCheckQuestion];
                        }
                            break;
                        case sc_chk_org:
                        {
                            sendStr = [self strResponseCheckOrganization];
                        }
                            break;
                        case sc_req_dt_que:
                        {
                            sendStr = [self strResponseQuestionData];
                        }
                            break;
                        case sc_req_dt_org:
                        {
                            sendStr = [self strResponseOrganizationData];
                        }
                            break;
                        case sc_noti_wait:
                        {
                            [Util setObject:@(waiting_vc) forKey:kUserInfoCurrentViewAtPepper];
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            [params setObject:@(stt_ok) forKey:JSON_KEY_STT_CODE];
                            sendStr = [self jsonStringPretty:params];
                            if (!isBlockForSetup) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    WaitingVC *waitingVC = [[WaitingVC alloc] initWithNibName:kNibWaitingVC bundle:nil];
                                    self.window.rootViewController = waitingVC;
                                });
                            }
                        }
                            break;
                        case sc_noti_appr:
                        {
                            [Util setObject:@(approach_vc) forKey:kUserInfoCurrentViewAtPepper];
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            [params setObject:@(stt_ok) forKey:JSON_KEY_STT_CODE];
                            sendStr = [self jsonStringPretty:params];
                            if (!isBlockForSetup) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    ApproachVC *approachVC = [[ApproachVC alloc] initWithNibName:kNibApproachVC bundle:nil];
                                    approachVC.isEnableSound = YES;
                                    self.window.rootViewController = approachVC;
                                });
                            }
                        }
                            break;
                        case sc_noti_cons:
                        {
                            [Util setObject:@(interview_vc) forKey:kUserInfoCurrentViewAtPepper];
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            [params setObject:@(stt_ok) forKey:JSON_KEY_STT_CODE];
                            sendStr = [self jsonStringPretty:params];
                            [Util setObject:@(0) forKey:kUserInfoQuestionIdAtPepper];
                            [Util setObject:@(0) forKey:kUserInfoAnswerIdAtPepper];
                            if (!isBlockForSetup) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    InterviewVC *interviewVC = [[InterviewVC alloc] initWithNibName:kNibInterviewVC bundle:nil];
                                    interviewVC.isEnableSound = YES;
                                    self.window.rootViewController = interviewVC;
                                });
                            }
                        }
                            break;
                        case sc_noti_recp:
                        {
                            [Util setObject:@(reception_vc) forKey:kUserInfoCurrentViewAtPepper];
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            [params setObject:@(stt_ok) forKey:JSON_KEY_STT_CODE];
                            sendStr = [self jsonStringPretty:params];
                            if (!isBlockForSetup) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    ReceptionVC *receptionVC = [[ReceptionVC alloc] initWithNibName:kNibReceptionVC bundle:nil];
                                    self.window.rootViewController = receptionVC;
                                });
                            }
                        }
                            break;
                        case sc_req_appo:
                        {
                            [Util setObject:@(appointment_vc) forKey:kUserInfoCurrentViewAtPepper];
//                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                            [params setObject:@(stt_ok) forKey:JSON_KEY_STT_CODE];
//                            sendStr = [self jsonStringPretty:params];
                            sendStr = @"";
                            NSInteger bumonId = [[recvDictionary objectForKey:JSON_KEY_BUMON_ID] integerValue];
                            NSInteger shainId = [[recvDictionary objectForKey:JSON_KEY_SHAIN_ID] integerValue];
                            
                            [Util setObject:@(bumonId) forKey:kUserInfoBumonIdAtPepper];
                            [Util setObject:@(shainId) forKey:kUserInfoShainIdAtPepper];
                            
                            if (!isBlockForSetup) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    AppointmentVC *appointmentVC = [[AppointmentVC alloc] initWithNibName:kNibAppointmentVC bundle:nil];
                                    appointmentVC.bumonId = bumonId;
                                    appointmentVC.shainId = shainId;
                                    appointmentVC.isEnableSound = YES;
                                    self.window.rootViewController = appointmentVC;
                                });
                            }
                        }
                            break;
                        case sc_req_no_appo:
                        {
                            [Util setObject:@(no_appointment_vc) forKey:kUserInfoCurrentViewAtPepper];
//                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                            [params setObject:@(stt_ok) forKey:JSON_KEY_STT_CODE];
//                            sendStr = [self jsonStringPretty:params];
                            sendStr = @"";
                            if (!isBlockForSetup) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NoAppointmentVC *noAppointmentVC = [[NoAppointmentVC alloc] initWithNibName:kNibNoAppointmentVC bundle:nil];
                                    noAppointmentVC.isEnableSound = YES;
                                    self.window.rootViewController = noAppointmentVC;
                                });
                            }
                        }
                            break;
                        case sc_ans_inter:
                        {
                            [Util setObject:@(interview_vc) forKey:kUserInfoCurrentViewAtPepper];
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            [params setObject:@(stt_ok) forKey:JSON_KEY_STT_CODE];
                            sendStr = [self jsonStringPretty:params];
                            
                            NSInteger questionId = [[recvDictionary objectForKey:JSON_KEY_QUESTION_ID] integerValue];
                            NSInteger answerId = [[recvDictionary objectForKey:JSON_KEY_ANSWER_ID] integerValue];
                            [Util setObject:@(questionId) forKey:kUserInfoQuestionIdAtPepper];
                            [Util setObject:@(answerId) forKey:kUserInfoAnswerIdAtPepper];
                        
                            if (!isBlockForSetup) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    InterviewVC *interviewVC = [[InterviewVC alloc] initWithNibName:kNibInterviewVC bundle:nil];
                                    interviewVC.questionId = questionId;
                                    interviewVC.answerId   = answerId;
                                    interviewVC.isEnableSound = NO;
                                    self.window.rootViewController = interviewVC;
                                });
                            }
                        }
                            break;
                        case sc_all_ans_inter:
                        {
                            NSArray *arrResults = [recvDictionary objectForKey:JSON_KEY_DATA];
                            for (int i = 0; i < [arrResults count]; i++) {
                                NSDictionary *dic = [arrResults objectAtIndex:i];
                                NSInteger questionId = [[dic objectForKey:JSON_AWS_QUESTION_ID] integerValue];
                                NSInteger answerId = [[dic objectForKey:JSON_AWS_ANSWER_ID] integerValue];
                                NSLog(@"Quesion ID : %ld ----- Answer ID : %ld", (long)questionId, (long)answerId);
                            }
#warning Test
                            NSString *strToken = @"qwertyuio1234567890";
//                            NSString *strToken = [Util objectForKey:kUserInfoAwsApiToken];
                            
                            if ([strToken isEqualToString:@""] || strToken == nil) {
                                [Util showMessage:kAlertMsgNotToken withTitle:kAlertMsgError];
                                return;
                            }
                            
                            [[APIClient sharedClient] sendConsultationResultsToAWS:strToken jsonData:arrResults completion:^(ResponseObject *obj) {
                                if (obj.statusCode == api_ok) {
                                    NSLog(@"send data to server done !");
                                }else{
                                    NSLog(@"Error : Send data to server !");
                                    [self processErrorCode:obj.statusCode errComment:obj.message];
                                }
                                
                            }];
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
            
            [ss sendData:sendStr];
            sleep(1);
        }
    }
}

- (NSString *)strResponseCheckQuestion
{
    NSString *currentUpdateTime = [[DataManager sharedInstance] getLastestUpdateTimeOfQuestionTbl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(ss_res_chk_que) forKey:JSON_KEY_STT_CODE];
    [params setObject:[Util validateString:currentUpdateTime] forKey:JSON_KEY_UPDATE_TIME];
    NSString *jsonData = [self jsonStringPretty:params];
    return jsonData;
}
- (NSString *)strResponseCheckOrganization
{
    NSString *currentUpdateTime = [[DataManager sharedInstance] getLastestUpdateTimeOfShainTbl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(ss_res_chk_org) forKey:JSON_KEY_STT_CODE];
    [params setObject:[Util validateString:currentUpdateTime] forKey:JSON_KEY_UPDATE_TIME];
    NSString *jsonData = [self jsonStringPretty:params];
    return jsonData;
}

// Get Question & Answer data
- (NSString *)strResponseQuestionData
{
    NSMutableArray *jsonArrQuestion = [[NSMutableArray alloc] init];
    NSArray *arrQuestion = [[DataManager sharedInstance] getAllQuestionData];
    for (int i = 0; i < [arrQuestion count]; i++) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        T_Question *q = [arrQuestion objectAtIndex:i];
        [jsonDict setObject:q.questionId forKey:@"questionId"];
        [jsonDict setObject:q.contents forKey:@"contents"];
        [jsonDict setObject:q.speech forKey:@"speech"];
        [jsonDict setObject:q.imageId forKey:@"imageId"];
        [jsonDict setObject:q.motionId forKey:@"motionId"];
        [jsonDict setObject:[Util validateString:q.updateTime] forKey:@"updateTime"];
        [jsonArrQuestion addObject:jsonDict];
    }
    
    NSMutableArray *jsonArrAnswer = [[NSMutableArray alloc] init];
    NSArray *arrAnswer   = [[DataManager sharedInstance] getAllAnswerData];
    for (int i = 0; i < [arrAnswer count]; i++) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        T_Answer *a = [arrAnswer objectAtIndex:i];
        [jsonDict setObject:a.answerId forKey:@"answerId"];
        [jsonDict setObject:a.contents forKey:@"contents"];
        [jsonDict setObject:a.questionId forKey:@"questionId"];
        [jsonDict setObject:a.nextQuestionId forKey:@"nextQuestionId"];
        [jsonDict setObject:a.imageId forKey:@"imageId"];
        [jsonDict setObject:a.resultContents forKey:@"resultContents"];
        [jsonDict setObject:a.resultImageId forKey:@"resultImageId"];
        [jsonDict setObject:[Util validateString:a.updateTime] forKey:@"updateTime"];
        [jsonArrAnswer addObject:jsonDict];
    }
    
    NSMutableArray *jsonArrImage = [[NSMutableArray alloc] init];
    NSArray *arrImage   = [[DataManager sharedInstance] getAllImageData];
    for (int i = 0; i < [arrImage count]; i++) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        T_Image *image = [arrImage objectAtIndex:i];
        [jsonDict setObject:image.imageId forKey:@"imageId"];
        [jsonDict setObject:image.url forKey:@"url"];
        [jsonDict setObject:image.name forKey:@"name"];
        [jsonDict setObject:[Util validateString:image.updateTime] forKey:@"updateTime"];
        [jsonArrImage addObject:jsonDict];
    }
    
    NSDictionary *dictData = @{JSON_KEY_QUESTION : jsonArrQuestion,
                                 JSON_KEY_ANSWER : jsonArrAnswer,
                                  JSON_KEY_IMAGE : jsonArrImage};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(ss_res_dt_que) forKey:JSON_KEY_STT_CODE];
    [params setObject:dictData forKey:JSON_KEY_DATA];
    NSString *jsonData = [self jsonStringPretty:params];
    return jsonData;
}

// Get Bumon, Shain data
- (NSString *)strResponseOrganizationData
{
    NSMutableArray *jsonArrBumon = [[NSMutableArray alloc] init];
    NSArray *arrBumon = [[DataManager sharedInstance] getAllBumonData];
    for (int i = 0; i < [arrBumon count]; i++) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        T_Bumon *bumon = [arrBumon objectAtIndex:i];
        [jsonDict setObject:bumon.bumonId forKey:@"bumonId"];
        [jsonDict setObject:bumon.name forKey:@"name"];
        [jsonDict setObject:[Util validateString:bumon.updateTime] forKey:@"updateTime"];
        [jsonArrBumon addObject:jsonDict];
    }

    NSMutableArray *jsonArrShain = [[NSMutableArray alloc] init];
    NSArray *arrShain= [[DataManager sharedInstance] getAllShainData];
    for (int i = 0; i < [arrShain count]; i++) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        T_Shain *shain = [arrShain objectAtIndex:i];
        [jsonDict setObject:shain.shainId forKey:@"shainId"];
        [jsonDict setObject:shain.name forKey:@"name"];
        [jsonDict setObject:shain.yomi forKey:@"yomi"];
        [jsonDict setObject:shain.bumonId forKey:@"bumonId"];
        [jsonDict setObject:[Util validateString:shain.updateTime] forKey:@"updateTime"];
        [jsonArrShain addObject:jsonDict];
    }
    
    NSDictionary *dictData = @{JSON_KEY_BUMON : jsonArrBumon,
                               JSON_KEY_SHAIN : jsonArrShain};

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(ss_res_dt_org) forKey:JSON_KEY_STT_CODE];
    [params setObject:dictData forKey:JSON_KEY_DATA];
    NSString *jsonData = [self jsonStringPretty:params];
    return jsonData;
}

- (NSString *)jsonStringPretty:(id)data
{
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
#pragma mark ----- UIInterfaceOrientation -----
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscape;
}
#pragma mark ----- RegisterDefaultsFromSettingsBundle ----
- (void)registerDefaultsValue
{
    // Set default value for Alarm
    [Util setObject:@(1) forKey:kUserAlarmIdDetectPeople];
    [Util setObject:@(2) forKey:kUserAlarmIdEnterQuestion];
    [Util setObject:@(3) forKey:kUserAlarmIdCallHasAppo];
    [Util setObject:@(4) forKey:kUserAlarmIdCallNoAppo];
    // Set default value for pepper volume is 30
    [Util setObject:@(30) forKey:kDefaultPepperVolume];
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
- (void)processErrorCode:(NSInteger)code errComment:(NSString *)comment{
    NSString *msg = [APIClient errorCodeMessageWithCode:code];
    if (comment != nil) {
        [Util showMessage:comment withTitle:kAlertMsgError];
    }else if (msg != nil){
        [Util showMessage:msg withTitle:kAlertMsgError];
    }
}
@end
