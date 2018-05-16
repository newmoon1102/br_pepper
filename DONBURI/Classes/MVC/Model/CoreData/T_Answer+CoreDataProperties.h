//
//  T_Answer+CoreDataProperties.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/28.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Answer+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_Answer (CoreDataProperties)

+ (NSFetchRequest<T_Answer *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *answerId;
@property (nullable, nonatomic, copy) NSString *contents;
@property (nullable, nonatomic, copy) NSNumber *nextQuestionId;
@property (nullable, nonatomic, copy) NSNumber *questionId;
@property (nullable, nonatomic, copy) NSString *updateTime;
@property (nullable, nonatomic, copy) NSNumber *imageId;
@property (nullable, nonatomic, copy) NSString *resultContents;
@property (nullable, nonatomic, copy) NSNumber *resultImageId;

@end

NS_ASSUME_NONNULL_END
