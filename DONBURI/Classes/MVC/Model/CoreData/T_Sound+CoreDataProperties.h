//
//  T_Sound+CoreDataProperties.h
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/25.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Sound+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_Sound (CoreDataProperties)

+ (NSFetchRequest<T_Sound *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *soundId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
