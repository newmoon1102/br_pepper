//
//  T_Bumon+CoreDataProperties.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/15.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Bumon+CoreDataProperties.h"

@implementation T_Bumon (CoreDataProperties)

+ (NSFetchRequest<T_Bumon *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"T_Bumon"];
}

@dynamic bumonId;
@dynamic name;
@dynamic updateTime;

@end
