//
//  T_Shain+CoreDataProperties.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/28.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Shain+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_Shain (CoreDataProperties)

+ (NSFetchRequest<T_Shain *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *bumonId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *shainId;
@property (nullable, nonatomic, copy) NSString *updateTime;
@property (nullable, nonatomic, copy) NSString *yomi;

@end

NS_ASSUME_NONNULL_END
