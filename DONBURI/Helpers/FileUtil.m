//
//  FileUtil.m
//  iPhoneLib,
//  Helper Functions and Classes for Ordinary Application Development on iPhone
//
//  Created by meinside on 10. 01. 16.
//
//  last update: 12.01.13.
//

#import "FileUtil.h"

#import "Logging.h"


@implementation FileUtil

#pragma mark -
#pragma mark file-related functions

+ (NSString*)pathForPathType:(PathType)type
{
	NSSearchPathDirectory directory;
	switch(type)
	{
		case PathTypeDocument:
			directory = NSDocumentDirectory;
			break;
		case PathTypeLibrary:
			directory = NSLibraryDirectory;
			break;
		case PathTypeBundle:
			return [[NSBundle mainBundle] bundlePath];
			break;
		case PathTypeResource:
			return [[NSBundle mainBundle] resourcePath];
			break;
		case PathTypeTemp:
			return NSTemporaryDirectory();
			break;
		case PathTypeCache:
			directory = NSCachesDirectory;
			break;
		default:
			return nil;
	}
	NSArray* directories = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
	if(directories != nil && [directories count] > 0)
		return [directories objectAtIndex:0];
	return nil;
}

+ (NSString*)pathOfFile:(NSString*)filename withPathType:(PathType)type
{
	return [[self pathForPathType:type] stringByAppendingPathComponent:filename];
}

+ (BOOL)fileExistsAtPath:(NSString*)path
{
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (uint64_t) sizeOfFile:(NSString *)filePath{
    NSFileManager * fileManager = [NSFileManager defaultManager];
	NSDictionary  * dict = [fileManager attributesOfItemAtPath:filePath error:nil];
	return [dict fileSize];
}

+ (BOOL)copyFileFromPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
	NSError* error;
	return [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:&error];
}
+ (BOOL)renameFileFormPath:(NSString*)srcPath toPath:(NSString*)dstPath
{
    NSError *error = nil;
    return [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error];
}
+ (BOOL)deleteFileAtPath:(NSString*)path
{
	NSError* error;
	return [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path withAttributes:(NSDictionary*)attributes
{
	NSError* error;
	return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:attributes error:&error];
}

+ (BOOL)createFileAtPath:(NSString*)path withData:(NSData*)data andAttributes:(NSDictionary*)attr
{
	return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:attr];
}

+ (BOOL)saveImageToDocuments:(UIImage *)image withName:(NSString *)imgName
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pathImgExist = [dir stringByAppendingPathComponent:imgName];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathImgExist])		//Does file exist?
    {
        if (![[NSFileManager defaultManager] removeItemAtPath:pathImgExist error:&error])	//Delete it
        {
            // Delete error
            return NO;
        }
    }
    if (image != nil)
    {
        NSString *pathImgSave = [dir stringByAppendingPathComponent:imgName];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:pathImgSave atomically:YES];
    }
    return YES;
}

+ (UIImage *)getImageFromDocumentWithName:(NSString *)imgName
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* path = [dir stringByAppendingPathComponent:imgName];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (NSData*)dataFromPath:(NSString *)path
{
	return [[NSFileManager defaultManager] contentsAtPath:path];
}

+ (NSArray*)contentsOfDirectoryAtPath:(NSString*)path
{
	NSError* error;
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
}

//referenced: http://stackoverflow.com/questions/2188469/calculate-the-size-of-a-folder
+ (unsigned long long int)sizeOfFolderPath:(NSString *)path
{
    unsigned long long int totalSize = 0;

	NSEnumerator* enumerator = [[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil] objectEnumerator];	
    NSString* fileName;
    while((fileName = [enumerator nextObject]))
	{
		totalSize += [[[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil] fileSize];
    }
	
    return totalSize;	
}

// Returns the URL to the application's Documents directory.
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)temporaryDirectory
{
    return NSTemporaryDirectory();
}

+ (BOOL) clearDataInDirectory:(NSString *)dir{
    if (dir) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL isDir;
        if([fileMgr fileExistsAtPath:dir isDirectory:&isDir] && isDir){
            NSArray *files = [fileMgr contentsOfDirectoryAtPath:dir error:nil];
            BOOL result = YES;
            for (NSString *filename in files) {
                result = result && [fileMgr removeItemAtPath:[dir stringByAppendingPathComponent:filename] error:nil];
            }
            return result;
        }
    }
    return NO;
}

+ (BOOL) clearDataInDocument{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [FileUtil clearDataInDirectory:dir];
}

@end
