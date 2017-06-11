//
//  ClockObject.h
//  Super
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ClockBlock)(id object);
@interface ClockObject : NSObject
{
 NSTimer * _timer ;
NSTimeInterval  _timeIntercal ;
    NSTimeInterval  _endTimeIntercal ;
  ClockBlock  _block ;
    NSDate *nowDate;
}
+(ClockObject *)defaultClockObject;
/**
 *  设置开始时间
 *就是所谓的服务器时间。
 */ 
@property(nonatomic,assign)NSTimeInterval  timeIntercal;
/**
 *用于抢购秒杀  倒计时
 *  @param endTimeIntercal endTimeIntercal description  结束时间
 *  @param block           返回格式  xx天xx:xx:xx  /   xx:xx:xx
 *使用规范      
 *如果项目里有且只有一个倒计时用单例没有问题，如果项目里有多个倒计时，并且每个倒计时的结束时间不一致那么需要用单例里面的开始时间，非单例模式下的调用该方法。
 */
-(void)setBeginTimeWithEndTimeIntercal:(NSTimeInterval)endTimeIntercal complete:(ClockBlock)block;
/**
 *
 *任意时间转成北京时间
 */
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
/**
 *  后台运行模式开始
 */
-(void)StartBackgroundRun;

@end
