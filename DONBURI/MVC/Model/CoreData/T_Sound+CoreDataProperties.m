//
//  T_Sound+CoreDataProperties.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/25.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Sound+CoreDataProperties.h"

@implementation T_Sound (CoreDataProperties)

+ (NSFetchRequest<T_Sound *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"T_Sound"];
}

@dynamic soundId;
@dynamic name;
@dynamic url;

@end
