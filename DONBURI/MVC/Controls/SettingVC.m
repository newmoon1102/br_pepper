//
//  SettingVC.m
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "SettingVC.h"
#import "MainVC.h"
#import "WaitingVC.h"
#import "ReceptionVC.h"
#import "ApproachVC.h"
#import "InterviewVC.h"
#import "AppointmentVC.h"
#import "NoAppointmentVC.h"

@interface SettingVC ()
{
    NSArray *arrSound;
}

@property (strong, nonatomic) IBOutlet UITextField *txtPickApproachSound;
@property (strong, nonatomic) IBOutlet UITextField *txtPickEnterQuestionSound;
@property (strong, nonatomic) IBOutlet UITextField *txtPickAppointSound;
@property (strong, nonatomic) IBOutlet UITextField *txtPickNoAppointSound;
@property (strong, nonatomic) IBOutlet UISlider    *sliderPepperVolume;
@property (strong, nonatomic) IBOutlet UITableView *tblPickSound;
@property (strong, nonatomic) IBOutlet UIView      *vSettingView;
@property (strong, nonatomic) IBOutlet UIView      *vPopupPickSound;
@property (strong, nonatomic) IBOutlet UIView      *vPopupGetData;
@property (strong, nonatomic) IBOutlet UILabel     *lbPepperVolume;

@property (assign, nonatomic) ErrorView *errView;

@property (nonatomic, strong) AudioPlayerManager   *auPlayer;
@property (nonatomic, assign) alarm_type   alarmType;
@property (nonatomic, assign) NSInteger    soundIdSelected;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.vPopupPickSound setHidden:YES];
    [self.vPopupGetData setHidden:YES];
    self.auPlayer = [[AudioPlayerManager alloc] init];
    arrSound = [[DataManager sharedInstance] getAllAlarmData];
    
    NSInteger sDetectPeopleId = [[Util objectForKey:kUserAlarmIdDetectPeople] integerValue];
    NSInteger sEnterQuestion = [[Util objectForKey:kUserAlarmIdEnterQuestion] integerValue];
    NSInteger sCallHasAppoId = [[Util objectForKey:kUserAlarmIdCallHasAppo] integerValue];
    NSInteger sCallNoAppoId = [[Util objectForKey:kUserAlarmIdCallNoAppo] integerValue];
    
    self.txtPickApproachSound.text = [[DataManager sharedInstance] getSoundNameWithId:sDetectPeopleId];
    self.txtPickEnterQuestionSound.text = [[DataManager sharedInstance] getSoundNameWithId:sEnterQuestion];
    self.txtPickAppointSound.text = [[DataManager sharedInstance] getSoundNameWithId:sCallHasAppoId];
    self.txtPickNoAppointSound.text = [[DataManager sharedInstance] getSoundNameWithId:sCallNoAppoId];
    
    self.sliderPepperVolume.minimumValue = 0.0;
    self.sliderPepperVolume.maximumValue = 100.0;
    [self.sliderPepperVolume setContinuous: NO];
    [self.sliderPepperVolume addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    int pepperVolume = [[Util objectForKey:kDefaultPepperVolume] intValue];
    self.sliderPepperVolume.value = pepperVolume;
    self.lbPepperVolume.text = [NSString stringWithFormat:@"%d",pepperVolume];
    [Util setObject:[NSNumber numberWithBool:YES] forKey:kUserInfoBlockForSetup];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [Util setObject:[NSNumber numberWithBool:NO] forKey:kUserInfoBlockForSetup];
}

- (void)showPopupPickSound
{
    if (self.alarmType == detect_people) {
        self.soundIdSelected = [[Util objectForKey:kUserAlarmIdDetectPeople] integerValue];
    }else if(self.alarmType == enter_question){
        self.soundIdSelected = [[Util objectForKey:kUserAlarmIdEnterQuestion] integerValue];
    }else if (self.alarmType == call_has_appoint){
        self.soundIdSelected = [[Util objectForKey:kUserAlarmIdCallHasAppo] integerValue];
    }else if (self.alarmType == call_no_appoint){
        self.soundIdSelected = [[Util objectForKey:kUserAlarmIdCallNoAppo] integerValue];
    }
    
    for (int i = 0; i < [arrSound count]; i++) {
        T_Sound *sound = [arrSound objectAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if (self.soundIdSelected == [sound.soundId integerValue]) {
            [self.tblPickSound selectRowAtIndexPath:indexPath animated:NO  scrollPosition:UITableViewScrollPositionNone];
        }else{
            [self.tblPickSound deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    
    [self.vPopupPickSound setHidden:NO];
    self.vPopupPickSound.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.vPopupPickSound.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.vPopupPickSound.alpha = 1;
        self.vPopupPickSound.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)hidePopupPickSound
{
    if ([self.auPlayer isPlaying]) {
        [self.auPlayer stopPlay];
    }
    
    [UIView animateWithDuration:.25 animations:^{
        self.vPopupPickSound.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.vPopupPickSound.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.vPopupPickSound setHidden:YES];
        }
    }];
}
- (void)showPopupGetData
{
    [self.vPopupGetData setHidden:NO];
    self.vPopupGetData.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.vPopupGetData.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.vPopupGetData.alpha = 1;
        self.vPopupGetData.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)hidePopupGetData
{
    [UIView animateWithDuration:.25 animations:^{
        self.vPopupGetData.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.vPopupGetData.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.vPopupGetData setHidden:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ----- UIAction -----
- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.lbPepperVolume.text = [NSString stringWithFormat:@"%ld",lroundf(sender.value)];
    NSInteger pepperVolume = lroundf(sender.value);
    [Util setObject:[NSNumber numberWithInteger:pepperVolume] forKey:kDefaultPepperVolume];
    
    SocketServer *socketServer = [SocketServer sharedSocket];
    NSMutableDictionary *strCode = [NSMutableDictionary dictionary];
    [strCode setObject:@(ss_setup_volume) forKey:JSON_KEY_STT_CODE];
    [strCode setObject:@(lroundf(sender.value)) forKey:JSON_KEY_VOLUME];
    NSString *sendStr = [self jsonStringPretty:strCode];
    if(socketServer){
        [socketServer sendData:sendStr];
    }
}

- (IBAction)btnPickApproachSoundClick:(id)sender {
//    [[AudioPlayerManager shareAudioManager] playEffectAudio:kSoundButton];
    self.alarmType = detect_people;
    [self showPopupPickSound];
}
- (IBAction)btnPickEnterQuestionSoundClick:(id)sender {
    self.alarmType = enter_question;
    [self showPopupPickSound];
}

- (IBAction)btnPickAppointSoundClick:(id)sender {
//    [[AudioPlayerManager shareAudioManager] playEffectAudio:kSoundButton];
    self.alarmType = call_has_appoint;
    [self showPopupPickSound];
}
- (IBAction)btnPickNoAppointSoundClick:(id)sender {
//    [[AudioPlayerManager shareAudioManager] playEffectAudio:kSoundButton];
    self.alarmType = call_no_appoint;
    [self showPopupPickSound];
}
- (IBAction)btnGetOrganizationChartClick:(id)sender {
//    [self showPopupGetData];
    [self getOrganizationFromAwsServer];
}
- (void)getOrganizationFromAwsServer
{
#warning Test
    NSString *strToken = @"qwertyuio1234567890";
    
    //    NSString *strToken = [Util objectForKey:kUserInfoAwsApiToken];
    if ([strToken isEqualToString:@""] || strToken == nil) {
        [Util showMessage:kAlertMsgNotToken withTitle:kAlertMsgError];
        return;
    }
    __block id copy_self = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = kMsgCheckStatusOrganization;
    
    [[APIClient sharedClient] checkUpdatedStatusOrganizationDb:strToken completion:^(ResponseObject *obj) {
        [hud hide:YES];
        if (obj.statusCode == api_ok) {
            NSString *soshikiUpdateTime = [Util validateString:obj.response[@"soshiki_updatetime"]];
            [copy_self processCheckStatusUpdateOrganization:soshikiUpdateTime];
        }else if(obj.statusCode == api_err_invalid || obj.statusCode == api_err_not_exist ||
                 obj.statusCode == api_err_system || obj.statusCode == api_err_system_mainten){
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorWithPopup:obj.statusCode errComment:obj.message currentApi:api_chk_get_org];
        }else{
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorCode:obj.statusCode errComment:obj.message];
        }
    }];
}
- (IBAction)btnGetInterviewQuestionClick:(id)sender {
//    [self showPopupGetData];
    [self getQuestionFromAwsServer];
}
- (void)getQuestionFromAwsServer
{
#warning Test
    NSString *strToken = @"qwertyuio1234567890";
    
    //    NSString *strToken = [Util objectForKey:kUserInfoAwsApiToken];
    if ([strToken isEqualToString:@""] || strToken == nil) {
        [Util showMessage:kAlertMsgNotToken withTitle:kAlertMsgError];
        return;
    }
    
    __block id copy_self = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = kMsgCheckStatusQuestion;
    
    [[APIClient sharedClient] checkUpdatedStatusQuestionDb:strToken completion:^(ResponseObject *obj) {
        [hud hide:YES];
        if (obj.statusCode == api_ok) {
            NSString *monshinUpdateTime = [Util validateString:obj.response[@"monshin_updatetime"]];
            [copy_self processCheckStatusUpdateQuestion:monshinUpdateTime];
        }else if(obj.statusCode == api_err_invalid || obj.statusCode == api_err_not_exist ||
                 obj.statusCode == api_err_system || obj.statusCode == api_err_system_mainten){
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorWithPopup:obj.statusCode errComment:obj.message currentApi:api_chk_get_que];
        }else{
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorCode:obj.statusCode errComment:obj.message];
        }
    }];
}
- (IBAction)btnPickSoundCancelClick:(id)sender {
//    [[AudioPlayerManager shareAudioManager] playEffectAudio:kSoundButton];
    [self hidePopupPickSound];
}
- (IBAction)btnPickSoundOkClick:(id)sender {
//    [[AudioPlayerManager shareAudioManager] playEffectAudio:kSoundButton];
    [self hidePopupPickSound];
    if (self.alarmType == detect_people) {
        [Util setObject:@(self.soundIdSelected) forKey:kUserAlarmIdDetectPeople];
        self.txtPickApproachSound.text = [[DataManager sharedInstance] getSoundNameWithId:self.soundIdSelected];
    }else if(self.alarmType == enter_question){
        [Util setObject:@(self.soundIdSelected) forKey:kUserAlarmIdEnterQuestion];
        self.txtPickEnterQuestionSound.text = [[DataManager sharedInstance] getSoundNameWithId:self.soundIdSelected];
    }else if (self.alarmType == call_has_appoint){
        [Util setObject:@(self.soundIdSelected) forKey:kUserAlarmIdCallHasAppo];
        self.txtPickAppointSound.text = [[DataManager sharedInstance] getSoundNameWithId:self.soundIdSelected];
    }else if (self.alarmType == call_no_appoint){
        [Util setObject:@(self.soundIdSelected) forKey:kUserAlarmIdCallNoAppo];
        self.txtPickNoAppointSound.text = [[DataManager sharedInstance] getSoundNameWithId:self.soundIdSelected];
    }
}
- (IBAction)btnGetDataOKClick:(id)sender {
//    [[AudioPlayerManager shareAudioManager] playEffectAudio:kSoundButton];
    [self hidePopupGetData];
}
- (IBAction)btnGetDataCancelClick:(id)sender {
//    [[AudioPlayerManager shareAudioManager] playEffectAudio:kSoundButton];
    [self hidePopupGetData];
}
- (IBAction)btnCloseSetupClick:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    int pepper_vc = [[Util objectForKey:kUserInfoCurrentViewAtPepper] intValue];
    switch (pepper_vc) {
        case waiting_vc:
        {
            WaitingVC *waitingVC = [[WaitingVC alloc] initWithNibName:kNibWaitingVC bundle:nil];
            appDelegate.window.rootViewController = waitingVC;
        }
            break;
        case reception_vc:
        {
            ReceptionVC *receptionVC = [[ReceptionVC alloc] initWithNibName:kNibReceptionVC bundle:nil];
            appDelegate.window.rootViewController = receptionVC;
        }
            break;
        case approach_vc:
        {
            ApproachVC *approachVC = [[ApproachVC alloc] initWithNibName:kNibApproachVC bundle:nil];
            approachVC.isEnableSound = YES;
            appDelegate.window.rootViewController = approachVC;
        }
            break;
        case interview_vc:
        {
            NSInteger questionId = [[Util objectForKey:kUserInfoQuestionIdAtPepper] integerValue];
            NSInteger answerId = [[Util objectForKey:kUserInfoAnswerIdAtPepper] integerValue];
            InterviewVC *interviewVC = [[InterviewVC alloc] initWithNibName:kNibInterviewVC bundle:nil];
            interviewVC.questionId = questionId;
            interviewVC.answerId = answerId;
            interviewVC.isEnableSound = YES;
            appDelegate.window.rootViewController = interviewVC;
        }
            break;
        case appointment_vc:
        {
            NSInteger bumonId = [[Util objectForKey:kUserInfoBumonIdAtPepper] integerValue];
            NSInteger shainId = [[Util objectForKey:kUserInfoShainIdAtPepper] integerValue];
            
            AppointmentVC *appointVC = [[AppointmentVC alloc] initWithNibName:kNibAppointmentVC bundle:nil];
            appointVC.bumonId = bumonId;
            appointVC.shainId = shainId;
            appointVC.isEnableSound = YES;
            appDelegate.window.rootViewController = appointVC;
        }
            break;
        case no_appointment_vc:
        {
            NoAppointmentVC *noAppointVC = [[NoAppointmentVC alloc] initWithNibName:kNibNoAppointmentVC bundle:nil];
            noAppointVC.isEnableSound = YES;
            appDelegate.window.rootViewController = noAppointVC;
        }
            break;
            
        default:{
            MainVC *mainVC = [[MainVC alloc] initWithNibName:kNibMainVC bundle:nil];
            appDelegate.window.rootViewController = mainVC;
        }
            break;
    }
}
#pragma mark ----- UITableViewDataSource & UITableViewDelegate -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSound count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if ([arrSound count] > 0) {
        T_Sound *sound = [arrSound objectAtIndex:indexPath.row];
        if (sound) {
            cell.textLabel.text = sound.name;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([arrSound count] > 0) {
        T_Sound *sound = [arrSound objectAtIndex:indexPath.row];
        if (sound){
            if ([self.auPlayer isPlaying] && [sound.url isEqualToString:self.auPlayer.audioFileName]) {
                [self.auPlayer stopPlay];
            }else{
                [self.auPlayer stopPlay];
                [self.auPlayer playAudioMenuNoLoop:sound.url inPathType:PathTypeResource];
            }
            self.soundIdSelected = [sound.soundId integerValue];
        }
    }
}

#pragma mark ----- Process Private Function -----
- (void)processCheckStatusUpdateOrganization:(NSString *)updateTime
{
    // Check updatetime
    NSString *currentUpdateTime = [[DataManager sharedInstance] getLastestUpdateTimeOfShainTbl];
    if ([currentUpdateTime isEqualToString:updateTime]) {
        [Util showMessage:kAlertMsgDontChangeUpdateTime withTitle:kAlertMsgTitle];
        return;
    }
    
#warning Test
    NSString *strToken = @"qwertyuio1234567890";
    
//    NSString *strToken = [Util objectForKey:kUserInfoAwsApiToken];
    if ([strToken isEqualToString:@""] || strToken == nil) {
        [Util showMessage:kAlertMsgNotToken withTitle:kAlertMsgError];
        return;
    }
    
    __block id copy_self = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = kMsgUpdateOrganization;
    
    [[DataManager sharedInstance] deleteAllShainData];
    [[DataManager sharedInstance] deleteAllBumonData];
    
    [[APIClient sharedClient] requestUpdateOrganizationDb:strToken completion:^(ResponseObject *obj) {
        [hud hide:YES];
        if (obj.statusCode == api_ok) {
            // Store array Soshiki
            NSArray *arrSoshiki = [Util convertToCorrectData:obj.response[@"soshiki_data"]];
            if ([arrSoshiki count] != 0) {
                for (int i = 0; i < [arrSoshiki count]; i++) {
                    NSDictionary *dic = [arrSoshiki objectAtIndex:i];
                    NSManagedObjectContext *localContext    = [NSManagedObjectContext contextForCurrentThread];
                    T_Shain *shain    = [T_Shain createInContext:localContext];
                    shain.shainId     = @([Util validateInt:[dic objectForKey:@"shain_id"]]);
                    shain.bumonId     = @([Util validateInt:[dic objectForKey:@"bumon_id"]]);
                    shain.name        = [Util validateString:[dic objectForKey:@"shain_name"]];
                    shain.yomi        = [Util validateString:[dic objectForKey:@"shain_yomi"]];
                    shain.updateTime  = [Util validateString:updateTime];
                    [localContext saveToPersistentStoreAndWait];
                }
            }
            
            // Store array Bumon
            NSArray *arrBumon = [Util convertToCorrectData:obj.response[@"bumon_list"]];
            if ([arrBumon count] != 0) {
                for (int i = 0; i < [arrBumon count]; i++) {
                    NSDictionary *dic = [arrBumon objectAtIndex:i];
                    NSManagedObjectContext *localContext    = [NSManagedObjectContext contextForCurrentThread];
                    T_Bumon *bumon    = [T_Bumon createInContext:localContext];
                    bumon.bumonId     = @([Util validateInt:[dic objectForKey:@"bumon_id"]]);
                    bumon.name        = [Util validateString:[dic objectForKey:@"bumon_name"]];
                    bumon.updateTime  = [Util validateString:updateTime];
                    [localContext saveToPersistentStoreAndWait];
                }
            }
            
        }else if(obj.statusCode == api_err_invalid || obj.statusCode == api_err_not_exist ||
                 obj.statusCode == api_err_system || obj.statusCode == api_err_system_mainten){
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorWithPopup:obj.statusCode errComment:obj.message currentApi:api_chk_get_org];
        }else{
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorCode:obj.statusCode errComment:obj.message];
        }
    }];
}

- (void)processCheckStatusUpdateQuestion:(NSString *)updateTime
{
    // Check updatetime
    NSString *currentUpdateTime = [[DataManager sharedInstance] getLastestUpdateTimeOfQuestionTbl];
    if ([currentUpdateTime isEqualToString:updateTime]) {
        [Util showMessage:kAlertMsgDontChangeUpdateTime withTitle:kAlertMsgTitle];
        return;
    }
#warning Test
    NSString *strToken = @"qwertyuio1234567890";
    
//    NSString *strToken = [Util objectForKey:kUserInfoAwsApiToken];
    if ([strToken isEqualToString:@""] || strToken == nil) {
        [Util showMessage:kAlertMsgNotToken withTitle:kAlertMsgError];
        return;
    }
    
    [[DataManager sharedInstance] deleteAllQuestionData];
    [[DataManager sharedInstance] deleteAllAnswerData];
    [[DataManager sharedInstance] deleteAllImageData];
    
    __block id copy_self = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = kMsgUpdateQuestion;
    
    [[APIClient sharedClient] requestUpdateQuestionDb:strToken completion:^(ResponseObject *obj) {
        [hud hide:YES];
        if (obj.statusCode == api_ok) {
            // Store array Question
            NSArray *arrQuestions = [Util convertToCorrectData:obj.response[@"monshin_data"]];
            if ([arrQuestions count] != 0) {
                for (int i = 0; i < [arrQuestions count]; i++) {
                    NSDictionary *dicQ = [arrQuestions objectAtIndex:i];
                    NSManagedObjectContext *localContext    = [NSManagedObjectContext contextForCurrentThread];
                    T_Question *question    = [T_Question createInContext:localContext];
                    question.questionId     = @([Util validateInt:[dicQ objectForKey:@"question_id"]]);
                    question.imageId        = @([Util validateInt:[dicQ objectForKey:@"question_imageid"]]);
                    question.motionId       = @([Util validateInt:[dicQ objectForKey:@"question_motionid"]]);
                    question.contents       = [Util validateString:[dicQ objectForKey:@"question_contents"]];
                    question.speech         = [Util validateString:[dicQ objectForKey:@"question_speech"]];
                    question.updateTime     = [Util validateString:updateTime];
                    [localContext saveToPersistentStoreAndWait];
                    
                    NSArray *arrAnswers = [dicQ objectForKey:@"answer"];
                    if ([arrAnswers count] != 0){
                        for (int j = 0; j < [arrAnswers count]; j++) {
                            NSDictionary *dicA = [arrAnswers objectAtIndex:j];
                            NSManagedObjectContext *localContext    = [NSManagedObjectContext contextForCurrentThread];
                            T_Answer *answer      = [T_Answer createInContext:localContext];
                            answer.answerId       = @([Util validateInt:[dicA objectForKey:@"answer_id"]]);
                            answer.questionId     = @([Util validateInt:[dicQ objectForKey:@"question_id"]]);
                            answer.contents       = [Util validateString:[dicA objectForKey:@"answer_contents"]];
                            answer.nextQuestionId = @([Util validateInt:[dicA objectForKey:@"answer_goto_question"]]);
                            answer.imageId        = @([Util validateInt:[dicA objectForKey:@"answer_imageid"]]);
                            answer.resultImageId  = @([Util validateInt:[dicA objectForKey:@"result_imageid"]]);
                            answer.resultContents = [Util validateString:[dicA objectForKey:@"result_contents"]];
                            answer.updateTime     = [Util validateString:updateTime];
                            
                            [localContext saveToPersistentStoreAndWait];
                        }
                    }
                }
            }
            
            // Store array Image
            NSArray *arrImages = [Util convertToCorrectData:obj.response[@"monshin_imgdatalist"]];
            if ([arrImages count] != 0) {
                for (int i = 0; i < [arrImages count]; i++) {
                    NSDictionary *dic = [arrImages objectAtIndex:i];
                    NSManagedObjectContext *localContext    = [NSManagedObjectContext contextForCurrentThread];
                    T_Image *image    = [T_Image createInContext:localContext];
                    image.imageId     = @([Util validateInt:[dic objectForKey:@"image_id"]]);
                    image.url         = [Util validateString:[dic objectForKey:@"image_url"]];
                    image.name        = @""; // AWS : haven't this value
                    image.updateTime  = [Util validateString:updateTime];
                    [localContext saveToPersistentStoreAndWait];
                }
            }
        }else if(obj.statusCode == api_err_invalid || obj.statusCode == api_err_not_exist ||
                 obj.statusCode == api_err_system || obj.statusCode == api_err_system_mainten){
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorWithPopup:obj.statusCode errComment:obj.message currentApi:api_chk_get_que];
        }else{
//            NSString *comment = [Util validateString:obj.message];
            [copy_self processErrorCode:obj.statusCode errComment:obj.message];
        }
    }];
}
- (NSString *)jsonStringPretty:(id)data
{
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
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
    if (currentApi == api_chk_get_org){
        [self getOrganizationFromAwsServer];
    }else if (currentApi == api_chk_get_que){
        [self getQuestionFromAwsServer];
    }
}

- (void)hideErrorView
{
    if (self.errView != nil) {
        [self.errView removeFromSuperview];
        self.errView = nil;
    }
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
