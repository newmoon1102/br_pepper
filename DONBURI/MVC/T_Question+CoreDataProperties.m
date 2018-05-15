//
//  T_Question+CoreDataProperties.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/11/16.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//
//

#import "T_Question+CoreDataProperties.h"

@implementation T_Question (CoreDataProperties)

+ (NSFetchRequest<T_Question *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"T_Question"];
}

@dynamic contents;
@dynamic imageId;
@dynamic questionId;
@dynamic speech;
@dynamic updateTime;
@dynamic motionId;

@end
