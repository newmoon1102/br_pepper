//
//  T_Question+CoreDataProperties.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/11/16.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//
//

#import "T_Question+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_Question (CoreDataProperties)

+ (NSFetchRequest<T_Question *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contents;
@property (nullable, nonatomic, copy) NSNumber *imageId;
@property (nullable, nonatomic, copy) NSNumber *questionId;
@property (nullable, nonatomic, copy) NSString *speech;
@property (nullable, nonatomic, copy) NSString *updateTime;
@property (nullable, nonatomic, copy) NSNumber *motionId;

@end

NS_ASSUME_NONNULL_END
