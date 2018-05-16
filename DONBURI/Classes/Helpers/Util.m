//
//  Util.m
//  DemoPepper
//
//  Created by OA-Promotion-Center on 2016/07/28.
//  Copyright © 2016 OA-Promotion-Center. All rights reserved.
//

#import "Util.h"

#define kCalendarType NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSTimeZoneCalendarUnit

@implementation Util

+ (Util *)sharedUtil {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void)dealloc {
    self.alertView = nil;
    self.progressView = nil;
    [super dealloc];
}

+ (AppDelegate *)appDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

#pragma mark Alert functions
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andDelegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = tag;
    [alert show];
    [alert release];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherTitle delegate:(id)delegate andTag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alert.tag = tag;
    alert.delegate = delegate;
    [alert show];
    [alert release];
    
}

#pragma mark Date functions
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setDateFormat:dateFormat];
    NSDate *ret = [formatter dateFromString:dateString];
    [formatter release];
    return ret;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:date];
    [formatter release];
    return ret;
}

+ (NSString *)stringFromDateString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *utcDate = [formatter dateFromString:dateString];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    [formatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    return [formatter stringFromDate:utcDate];
}

+ (NSDate*)convertTwitterDateToNSDate:(NSString*)created_at
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"US"]];
	
	NSDate *convertedDate = [dateFormatter dateFromString:created_at];
	[dateFormatter release];
	
    return convertedDate;
}

+ (NSString *)stringFromDateRelative:(NSDate*)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateStyle: NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
	[dateFormatter setDoesRelativeDateFormatting:YES];
	
	NSString *result = [dateFormatter stringFromDate:date];
	
	return result;
}
#pragma mark NSUserDefaults functions
+ (void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKeyPath:keyPath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)valueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (id)valueForKeyPath:(NSString *)keyPath
{
    return [[NSUserDefaults standardUserDefaults] valueForKeyPath:keyPath];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark JSON functions
+ (id)convertJSONToObject:(NSString*)str {
	NSError *error = nil;
	NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *responseDict;
	
	if (data) {
		responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
	} else {
		responseDict = nil;
	}
	
	return responseDict;
}

+ (NSString *)convertObjectToJSON:(id)obj {
	NSError *error = nil;
	NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
	
	if (error) {
		return @"";
	}
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (id)getJSONObjectFromFile:(NSString *)file {
	NSString *textPAth = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
	
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:textPAth encoding:NSUTF8StringEncoding error:&error];  //error checking omitted
	
	id returnData = [Util convertJSONToObject:content];
	return returnData;
}

#pragma mark Other stuff
+(UIView *)getView:(Class)fromClass{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:[Util getXIB:fromClass] owner:nil options:nil];
	for (UIView *view in views) {
		if([view isKindOfClass:fromClass]) {
			return view;
			break;
		}
	}
	return nil;
}

+ (NSString *)getXIB:(Class)fromClass
{
	NSString *className = NSStringFromClass(fromClass);
	if (IS_IPAD()) {
		className = [className stringByAppendingString:IPAD_XIB_POSTFIX];
	} else {
		
	}
	return className;
}

+ (UITableViewCell*)getCell:(Class)fromClass owner:(id) owner{
    NSArray *nib = nil;
    if(IS_IPAD()){
        nib = [[NSBundle mainBundle] loadNibNamed:[NSStringFromClass(fromClass) stringByAppendingString:IPAD_XIB_POSTFIX]
                                            owner:owner options:nil];
    }
    else{
        nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(fromClass)
                                            owner:owner options:nil];
    }
    for (id oneObject in nib)
        if ([oneObject isKindOfClass:fromClass]){
            return (UITableViewCell *)oneObject;
        }
    return nil;
}

#pragma mark -  UUID
+ (NSString *)generateUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (NSString *)string;
}

+ (NSString *)documentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

#pragma mark - Get Image from Document
// Check image in bundle
- (BOOL)existImageInBundle:(NSString *)imgName
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documentsPath stringByAppendingPathComponent:imgName];
    BOOL existImage = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return existImage;
}
// Loading image from bundle
+ (UIImage *)loadImage:(NSString *)imgName
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [documentsPath stringByAppendingPathComponent:imgName];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

#pragma mark ----- Validate ------
+ (int)validateInt:(id)num
{
    if ((num == [NSNull null]) || ([num isKindOfClass:[NSString class]] && [num isEqualToString:@""])) {
        return -1;
    }
    return [num intValue];
}

+ (NSString *)validateString:(id)str
{
    return (str != [NSNull null]) ? str : @"";
}

+ (NSInteger)validateInteger:(id)num
{
    if ((num == [NSNull null]) || ([num isKindOfClass:[NSString class]] && [num isEqualToString:@""])) {
        return -1;
    }
    return [num integerValue];
}
+ (float)validateFloat:(id)num
{
    return (num != [NSNull null]) ? [num floatValue] : 0.0f;
}
+ (id)convertToCorrectData:(id)response
{
    id correctData = response;
    if([response isKindOfClass:[NSDictionary class]]){
        correctData = [NSMutableDictionary dictionary];
        NSArray *keyArray = [response allKeys];
        for (NSString *key in keyArray) {
            id obj = [response objectForKey:key];
            if([obj isKindOfClass:[NSNull class]])
                obj = @"";
            [correctData setObject:obj forKey:key];
        }
    }else if([response isKindOfClass:[NSArray class]]){
        correctData = [NSMutableArray array];
        for (NSDictionary *dic in response) {
            NSMutableDictionary *nDict = [NSMutableDictionary dictionary];
            NSArray *keyArray = [dic allKeys];
            for (NSString *key in keyArray) {
                id obj = [dic objectForKey:key];
                if([obj isKindOfClass:[NSNull class]])
                    obj = @"";
                [nDict setObject:obj forKey:key];
            }
            [correctData addObject:nDict];
        }
    }
    return correctData;
}
@end


