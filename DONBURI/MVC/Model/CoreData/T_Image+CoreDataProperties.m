//
//  T_Image+CoreDataProperties.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/15.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Image+CoreDataProperties.h"

@implementation T_Image (CoreDataProperties)

+ (NSFetchRequest<T_Image *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"T_Image"];
}

@dynamic imageId;
@dynamic name;
@dynamic updateTime;
@dynamic url;

@end
