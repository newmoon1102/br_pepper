//
//  T_Image+CoreDataProperties.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/15.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Image+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_Image (CoreDataProperties)

+ (NSFetchRequest<T_Image *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *imageId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *updateTime;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
