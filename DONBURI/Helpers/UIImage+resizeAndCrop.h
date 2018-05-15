//
//  UIImage+resizeAndCrop.h
//  KitchenTimer
//
//  Created by 株式会社OA推進センター on 2016/06/29.
//  Copyright © 2016年 OA-Center Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (resizeAndCrop)
- (UIImage *)resizeToSize:(CGSize)newSize thenCropWithRect:(CGRect)cropRect;
@end
