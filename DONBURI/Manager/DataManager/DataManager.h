//
//  DataManager.h
//  DemoPepper
//
//  Created by 株式会社OA推進センター on 2016/11/04.
//  Copyright © 2016年 OA-Promotion-Center. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataManager : NSObject
+ (DataManager*)sharedInstance;
- (void)clearDB;
- (void)initData;

- (NSArray *)getAllBumonData;
- (NSArray *)getAllShainData;
- (NSArray *)getAllQuestionData;
- (NSArray *)getAllAnswerData;
- (NSArray *)getAllImageData;
- (NSArray *)getAllAlarmData;

- (T_Bumon *)getBumonWithId:(NSInteger)bumonId;
- (T_Shain *)getShainWithId:(NSInteger)shainId;
- (T_Question *)getQuestionWithId:(NSInteger)questionId;
- (T_Answer *)getAnswerWithId:(NSInteger)answerId;
- (T_Image *)getImageWithId:(NSInteger)imageId;
- (T_Sound *)getSoundWithId:(NSInteger)soundId;

- (NSString *)getLastestUpdateTimeOfShainTbl;
- (NSString *)getLastestUpdateTimeOfQuestionTbl;

- (BOOL)isExistBumonWithId:(NSInteger)bumonId;
- (BOOL)isExistShainWithId:(NSInteger)shainId;
- (BOOL)isExistQuestionWithId:(NSInteger)questionId;
- (BOOL)isExistAnswerWithId:(NSInteger)answerId;
- (BOOL)isExistImageWithId:(NSInteger)imageId;

- (BOOL)updateBumon:(T_Bumon *)bumon;
- (BOOL)updateShain:(T_Shain *)shain;
- (BOOL)updateQuestion:(T_Question *)question;
- (BOOL)updateAnswer:(T_Answer *)answer;
- (BOOL)updateImage:(T_Image *)image;

- (BOOL)deleteAllBumonData;
- (BOOL)deleteAllShainData;
- (BOOL)deleteAllQuestionData;
- (BOOL)deleteAllAnswerData;
- (BOOL)deleteAllImageData;

- (NSString *)getSoundNameWithId:(NSInteger)soundId;

@end
