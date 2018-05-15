//
//  T_Answer+CoreDataProperties.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/28.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Answer+CoreDataProperties.h"

@implementation T_Answer (CoreDataProperties)

+ (NSFetchRequest<T_Answer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"T_Answer"];
}

@dynamic answerId;
@dynamic contents;
@dynamic nextQuestionId;
@dynamic questionId;
@dynamic updateTime;
@dynamic imageId;
@dynamic resultContents;
@dynamic resultImageId;

@end
