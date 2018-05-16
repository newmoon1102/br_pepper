//
//  T_LastUpdated+CoreDataProperties.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/15.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_LastUpdated+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_LastUpdated (CoreDataProperties)

+ (NSFetchRequest<T_LastUpdated *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *lastUpdatedId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
