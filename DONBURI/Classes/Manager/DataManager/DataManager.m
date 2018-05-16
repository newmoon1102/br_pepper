//
//  DataManager.m
//  DemoPepper
//
//  Created by 株式会社OA推進センター on 2016/11/04.
//  Copyright © 2016年 OA-Promotion-Center. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
+ (DataManager*)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}
- (void)clearDB{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    NSURL *dbPath = [NSPersistentStore MR_urlForStoreName:[appName stringByAppendingString:@".sqlite"]];
    if([[NSFileManager defaultManager] fileExistsAtPath:[dbPath path]]){
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:dbPath error:&error];
    }
    [MagicalRecord cleanUp];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[appName stringByAppendingString:@".sqlite"]];
}

- (void)initData
{
    [self initAlarmDB];
}

- (void)initAlarmDB
{
    NSManagedObjectContext *localContext    = [NSManagedObjectContext contextForCurrentThread];
    
    T_Sound *sound1 = [T_Sound createInContext:localContext];
    sound1.soundId  = @(1);
    sound1.name     = @"アラーム１";
    sound1.url      = @"Alarm_1.mp3";
    
    T_Sound *sound2 = [T_Sound createInContext:localContext];
    sound2.soundId  = @(2);
    sound2.name     = @"アラーム２";
    sound2.url      = @"Alarm_2.mp3";
    
    T_Sound *sound3 = [T_Sound createInContext:localContext];
    sound3.soundId  = @(3);
    sound3.name     = @"アラーム３";
    sound3.url      = @"Alarm_3.mp3";
    
    T_Sound *sound4 = [T_Sound createInContext:localContext];
    sound4.soundId  = @(4);
    sound4.name     = @"アラーム４";
    sound4.url      = @"Alarm_4.mp3";
    
    T_Sound *sound5 = [T_Sound createInContext:localContext];
    sound5.soundId  = @(5);
    sound5.name     = @"アラーム５";
    sound5.url      = @"Alarm_5.mp3";
    
    T_Sound *sound6 = [T_Sound createInContext:localContext];
    sound6.soundId  = @(6);
    sound6.name     = @"アラーム６";
    sound6.url      = @"Alarm_6.mp3";
    
    T_Sound *sound7 = [T_Sound createInContext:localContext];
    sound7.soundId  = @(7);
    sound7.name     = @"アラーム７";
    sound7.url      = @"Alarm_7.mp3";
    
    T_Sound *sound8 = [T_Sound createInContext:localContext];
    sound8.soundId  = @(8);
    sound8.name     = @"アラーム８";
    sound8.url      = @"Alarm_8.mp3";
    
    T_Sound *sound9 = [T_Sound createInContext:localContext];
    sound9.soundId  = @(9);
    sound9.name     = @"アラーム９";
    sound9.url      = @"Alarm_9.mp3";
    
    T_Sound *sound10 = [T_Sound createInContext:localContext];
    sound10.soundId  = @(10);
    sound10.name     = @"アラーム１０";
    sound10.url      = @"Alarm_10.mp3";
    
    [localContext saveToPersistentStoreAndWait];
}

- (NSArray *)getAllBumonData{
    NSArray *arrData = [T_Bumon findAllSortedBy:@"bumonId" ascending:YES];
    return arrData;
}

- (NSArray *)getAllShainData{
    NSArray *arrData = [T_Shain findAllSortedBy:@"shainId" ascending:YES];
    return arrData;
}
- (NSArray *)getAllQuestionData{
    NSArray *arrData = [T_Question findAllSortedBy:@"questionId" ascending:YES];
    return arrData;
}
- (NSArray *)getAllAnswerData{
    NSArray *arrData = [T_Answer findAllSortedBy:@"answerId" ascending:YES];
    return arrData;
}
- (NSArray *)getAllImageData{
    NSArray *arrData = [T_Image findAllSortedBy:@"imageId" ascending:YES];
    return arrData;
}
- (NSArray *)getAllAlarmData
{
    NSArray *arrData = [T_Sound findAllSortedBy:@"soundId" ascending:YES];
    return arrData;
}

- (NSString *)getLastestUpdateTimeOfShainTbl{
    T_Shain *shain = [T_Shain findFirstOrderedByAttribute:@"updateTime" ascending:NO];
    if (shain) {
        return shain.updateTime;
    }
    return @"";
}
- (NSString *)getLastestUpdateTimeOfQuestionTbl{
    T_Question *question = [T_Question findFirstOrderedByAttribute:@"updateTime" ascending:NO];
    if (question) {
        return question.updateTime;
    }
    return @"";
}

- (T_Bumon *)getBumonWithId:(NSInteger)bumonId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bumonId == %d", bumonId];
    T_Bumon *bumon = [T_Bumon findFirstWithPredicate:predicate];
    if (bumon) {
        return bumon;
    }
    return nil;
}
- (T_Shain *)getShainWithId:(NSInteger)shainId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shainId == %d", shainId];
    T_Shain *shain = [T_Shain findFirstWithPredicate:predicate];
    if (shain) {
        return shain;
    }
    return nil;
}
- (T_Question *)getQuestionWithId:(NSInteger)questionId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questionId == %d", questionId];
    T_Question *question = [T_Question findFirstWithPredicate:predicate];
    if (question) {
        return question;
    }
    return nil;
}
- (T_Answer *)getAnswerWithId:(NSInteger)answerId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"answerId == %d", answerId];
    T_Answer *answer = [T_Answer findFirstWithPredicate:predicate];
    if (answer) {
        return answer;
    }
    return nil;
}
- (T_Image *)getImageWithId:(NSInteger)imageId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %d", imageId];
    T_Image *image = [T_Image findFirstWithPredicate:predicate];
    if (image) {
        return image;
    }
    return nil;
}
- (T_Sound *)getSoundWithId:(NSInteger)soundId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"soundId == %d", soundId];
    T_Sound *sound = [T_Sound findFirstWithPredicate:predicate];
    if (sound) {
        return sound;
    }
    return nil;
}

- (BOOL)isExistBumonWithId:(NSInteger)bumonId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bumonId == %d", bumonId];
    T_Bumon *bumon = [T_Bumon findFirstWithPredicate:predicate];
    if (bumon) {
        return YES;
    }
    return NO;
}

- (BOOL)isExistShainWithId:(NSInteger)shainId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shainId == %d", shainId];
    T_Shain *shain = [T_Shain findFirstWithPredicate:predicate];
    if (shain) {
        return YES;
    }
    return NO;
}
- (BOOL)isExistQuestionWithId:(NSInteger)questionId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questionId == %d", questionId];
    T_Question *question = [T_Question findFirstWithPredicate:predicate];
    if (question) {
        return YES;
    }
    return NO;
}
- (BOOL)isExistAnswerWithId:(NSInteger)answerId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"answerId == %d", answerId];
    T_Answer *answer = [T_Answer findFirstWithPredicate:predicate];
    if (answer) {
        return YES;
    }
    return NO;
}
- (BOOL)isExistImageWithId:(NSInteger)imageId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %d", imageId];
    T_Image *image = [T_Image findFirstWithPredicate:predicate];
    if (image) {
        return YES;
    }
    return NO;
}

- (BOOL)updateBumon:(T_Bumon *)bumon{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bumonId == %d", [bumon.bumonId integerValue]];
    T_Bumon *b = [T_Bumon findFirstWithPredicate:predicate inContext:localContext];
    if (b)
    {
        b.name       = bumon.name;
        b.updateTime = bumon.updateTime;
        [localContext saveToPersistentStoreAndWait];
        return YES;
    }
    return NO;
}

- (BOOL)updateShain:(T_Shain *)shain{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shainId == %d", [shain.shainId integerValue]];
    T_Shain *s = [T_Shain findFirstWithPredicate:predicate inContext:localContext];
    if (s)
    {
        s.name          = shain.name;
        s.yomi          = shain.yomi;
        s.bumonId       = shain.bumonId;
        s.updateTime    = shain.updateTime;
        [localContext saveToPersistentStoreAndWait];
        return YES;
    }
    return NO;
}
- (BOOL)updateQuestion:(T_Question *)question{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questionId == %d", [question.questionId integerValue]];
    T_Question *q = [T_Question findFirstWithPredicate:predicate inContext:localContext];
    if (q)
    {
        q.contents      = question.contents;
        q.imageId       = question.imageId;
        q.motionId      = question.motionId;
        q.speech        = question.speech;
        q.updateTime    = question.updateTime;
        [localContext saveToPersistentStoreAndWait];
        return YES;
    }
    return NO;
}
- (BOOL)updateAnswer:(T_Answer *)answer{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"answerId == %d", [answer.answerId integerValue]];
    T_Answer *a = [T_Answer findFirstWithPredicate:predicate inContext:localContext];
    if (a)
    {
        a.contents          = answer.contents;
        a.nextQuestionId    = answer.nextQuestionId;
        a.questionId        = answer.questionId;
        a.imageId           = answer.imageId;
        a.resultContents    = answer.resultContents;
        a.resultImageId     = answer.resultImageId;
        a.updateTime        = answer.updateTime;
        [localContext saveToPersistentStoreAndWait];
        return YES;
    }
    return NO;
}
- (BOOL)updateImage:(T_Image *)image{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imageId == %d", [image.imageId integerValue]];
    T_Image *i = [T_Image findFirstWithPredicate:predicate inContext:localContext];
    if (i)
    {
        i.name          = image.name;
        i.url           = image.url;
        i.updateTime    = image.updateTime;
        [localContext saveToPersistentStoreAndWait];
        return YES;
    }
    return NO;
}

- (BOOL)deleteAllBumonData
{
    BOOL ret = false;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    ret = [T_Bumon truncateAllInContext:localContext];
    return ret;
}
- (BOOL)deleteAllShainData
{
    BOOL ret = false;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    ret = [T_Shain truncateAllInContext:localContext];
    return ret;
}
- (BOOL)deleteAllQuestionData
{
    BOOL ret = false;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    ret = [T_Question truncateAllInContext:localContext];
    return ret;
}
- (BOOL)deleteAllAnswerData
{
    BOOL ret = false;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    ret = [T_Answer truncateAllInContext:localContext];
    return ret;
}
- (BOOL)deleteAllImageData
{
    BOOL ret = false;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    ret = [T_Image truncateAllInContext:localContext];
    return ret;
}

- (NSString *)getSoundNameWithId:(NSInteger)soundId{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"soundId == %d", soundId];
    T_Sound *sound = [T_Sound findFirstWithPredicate:predicate];
    if (sound) {
        return sound.name;
    }
    return nil;
}
@end
