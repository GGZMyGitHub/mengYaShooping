//
//  GZCacheTool.m
//  DongHeng
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZCacheTool.h"

@implementation GZCacheTool

+ (void)cacheForData:(NSData *)data fileName:(NSString *)fileName
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:[self getPath:fileName] atomically:YES];
    });
}


+ (NSData *)getCacheFileName:(NSString *)fileName
{
    return [[NSData alloc] initWithContentsOfFile:[self getPath:fileName]];
}

+ (NSUInteger)getAFNSize
{
    NSUInteger size = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        size += [attrs fileSize];
    }
    return size;
}

+ (NSUInteger)getSize
{
    //获取AFN的缓存大小
    NSUInteger afnSize = [self getAFNSize];
    return afnSize;
}

+ (void)clearAFNCache
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:kCachePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [kCachePath stringByAppendingPathComponent:fileName];
        
        [fm removeItemAtPath:filePath error:nil];
        
    }
}

+ (void)clearCache
{
    [self clearAFNCache];
}

+ (BOOL)isExpire:(NSString *)fileName
{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *attributesDict = [fm attributesOfItemAtPath:[self getPath:fileName] error:nil];
    NSDate *fileModificationDate = attributesDict[NSFileModificationDate];
    NSTimeInterval fileModificationTimestamp = [fileModificationDate timeIntervalSince1970];
    //现在的时间戳
    NSTimeInterval nowTimestamp = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    return ((nowTimestamp-fileModificationTimestamp)>kYBCache_Expire_Time);
}

+ (NSString *)getPath:(NSString *)fileName
{
    NSString *time = [NSString stringWithFormat:@"%.0f",[ClockObject defaultClockObject].timeIntercal];
    
    NSString *appkey=@"142575354532";
    NSString *appSecret=@"726NlYPfpU2Sh6Fc646Bgg";
    
    NSString *path = [kCachePath stringByAppendingPathComponent:[fileName Des_3EncryptForTimeInterval:time Appkey:appkey AppSecret:appSecret]];
    return path;
}

@end
