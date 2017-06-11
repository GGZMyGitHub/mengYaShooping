//
//  ClockObject.m
//  Super
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ClockObject.h"
#import "NSString+Helper.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
static ClockObject * _sharedInstance = nil;

@implementation ClockObject
+(ClockObject *)defaultClockObject{
    @synchronized ([ClockObject class]) {
        if (!_sharedInstance) {
            _sharedInstance=[[super alloc] init];
            [_sharedInstance timerRunWhenAppInBackground];
        }
        return _sharedInstance;
    }
        return nil;
}
-(void)timerRunWhenAppInBackground
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback
                                           error: &setCategoryErr];
    [[AVAudioSession sharedInstance]  setActive: YES
                                          error: &activationErr];
}
-(void)setBeginTimeWithEndTimeIntercal:(NSTimeInterval)endTimeIntercal complete:(ClockBlock)block{
    _block=block;
    _endTimeIntercal=endTimeIntercal;
}
-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}
-(void)setTimeIntercal:(NSTimeInterval)timeIntercal{
    _timeIntercal=timeIntercal;
    nowDate=[NSDate dateWithTimeIntervalSince1970:_timeIntercal];
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startOneOffTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}
-(void)startOneOffTimer{
    nowDate=[NSDate dateWithTimeInterval:1 sinceDate:nowDate];
    _timeIntercal=[nowDate timeIntervalSince1970];
    NSDate *enddata=[NSDate dateWithTimeIntervalSince1970:_endTimeIntercal];
    NSInteger shijiancha= [enddata timeIntervalSinceDate: nowDate];
    NSString *result=  [NSString TimeformatFromSeconds:shijiancha];
    if (shijiancha<=0) {
        result=@"00:00:00";
    }
    if (_block) {
        _block(result);
    }
}
/**
 *  任意时间转成北京时间
 *
 */
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置转换后的目标日期时区
 NSTimeZone* sourceTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone * destinationTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
/**
 *  后台运行模式开始
 */
-(void)StartBackgroundRun{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

@end
