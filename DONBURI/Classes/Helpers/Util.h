//
//  Util.h
//  DemoPepper
//
//  Created by OA-Promotion-Center on 2016/07/28.
//  Copyright © 2016 OA-Promotion-Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "GCDispatch.h"

@interface Util : NSObject

@property (strong, nonatomic) MBProgressHUD *progressView;
@property (strong, nonatomic) UIAlertView *alertView;

+ (Util *)sharedUtil;
+ (AppDelegate *)appDelegate;

//Alert functions
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag;

//Date functions
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;
+ (NSString *)stringFromDateString:(NSString *)dateString;
+ (NSDate*)convertTwitterDateToNSDate:(NSString*)created_at;
+ (NSString *)stringFromDateRelative:(NSDate*)date;

//NSUserDefaults functions
+ (void)setValue:(id)value forKey:(NSString *)key;
+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)valueForKey:(NSString *)key;
+ (id)valueForKeyPath:(NSString *)keyPath;
+ (id)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;

//JSON functions
+ (id)convertJSONToObject:(NSString*)str;
+ (NSString *)convertObjectToJSON:(id)obj;
+ (id)getJSONObjectFromFile:(NSString *)file;

//Other stuff
+ (NSString *)getXIB:(Class)fromClass;
+ (UIView *)getView:(Class)fromClass;
+ (UITableViewCell*)getCell:(Class)fromClass owner:(id) owner;

//UUID
+ (NSString *)generateUUID;

+ (NSString *)documentPath;

+ (UIImage *)loadImage:(NSString *)imgName;

#pragma mark ----- Validate ------
+ (int)validateInt:(id)num;
+ (NSString *)validateString:(id)str;
+ (NSInteger)validateInteger:(id)num;
+ (float)validateFloat:(id)num;
+ (id)convertToCorrectData:(id)response;
@end
