//
//  T_LastUpdated+CoreDataProperties.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/15.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_LastUpdated+CoreDataProperties.h"

@implementation T_LastUpdated (CoreDataProperties)

+ (NSFetchRequest<T_LastUpdated *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"T_LastUpdated"];
}

@dynamic lastUpdatedId;
@dynamic name;
@dynamic updateTime;

@end
