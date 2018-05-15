//
//  T_Bumon+CoreDataProperties.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/15.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Bumon+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_Bumon (CoreDataProperties)

+ (NSFetchRequest<T_Bumon *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *bumonId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
