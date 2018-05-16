//
//  InterviewVC.m
//  PepperManager
//
//  Created by 株式会社OA推進センター on 2017/07/26.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "InterviewVC.h"

@interface InterviewVC ()
@property (strong, nonatomic) IBOutlet UILabel *lbQuestion;
@property (weak, nonatomic) IBOutlet UILabel *lbAnswer;
@property (weak, nonatomic) IBOutlet UIImageView *imgAnswer;
@property (nonatomic, strong) AudioPlayerManager *auPlayer;

@end

@implementation InterviewVC

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
        NSInteger soundId = [[Util objectForKey:kUserAlarmIdEnterQuestion] integerValue];
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
    
    T_Question *question = [[DataManager sharedInstance] getQuestionWithId:self.questionId];
    T_Answer *answer = [[DataManager sharedInstance] getAnswerWithId:self.answerId];
    
    if (question) {
        self.lbQuestion.text = question.contents;
    }
    if (answer) {
        self.lbAnswer.text = answer.contents;
        T_Image *image = [[DataManager sharedInstance] getImageWithId:[answer.imageId integerValue]];
        if (image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.url]];
                //set your image on main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imgAnswer setImage:[UIImage imageWithData:data]];
                });
            });
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isEnableSound = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [Util setObject:@(interview_vc) forKey:kUserInfoCurrentViewAtPepper];
    [Util setObject:@(self.questionId) forKey:kUserInfoQuestionIdAtPepper];
    [Util setObject:@(self.answerId) forKey:kUserInfoAnswerIdAtPepper];
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
