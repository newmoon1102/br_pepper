//
//  T_Shain+CoreDataProperties.m
//  DONBURI
//
//  Created by 株式会社OA推進センター on 2017/09/28.
//  Copyright © 2017年 OA-Promotion-Center. All rights reserved.
//

#import "T_Shain+CoreDataProperties.h"

@implementation T_Shain (CoreDataProperties)

+ (NSFetchRequest<T_Shain *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"T_Shain"];
}

@dynamic bumonId;
@dynamic name;
@dynamic shainId;
@dynamic updateTime;
@dynamic yomi;

@end
