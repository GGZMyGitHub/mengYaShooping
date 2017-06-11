//
//  GZNetworkSingleton.h
//  DongHeng
//
//  Created by apple on 17/3/14.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//
//////////////////////不带缓存的网络请求，以前写的/////////////


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//typedef NS_ENUM(NSUInteger, NetworkStates) {
//    NetworkStatesNone, // 没有网络
//    NetworkStates2G, // 2G
//    NetworkStates3G, // 3G
//    NetworkStates4G, // 4G
//    NetworkStatesWIFI // WIFI
//};

//请求超时
#define TIMEOUT 30

typedef void(^SuccessBlock)(id responseBody);

typedef void(^FailureBlock)(NSString *error);

@interface GZNetworkSingleton : NSObject

+(GZNetworkSingleton *)sharedManager;
-(AFHTTPSessionManager *)baseHtppRequest;

#pragma mark - GET

/** GET请求 */
-(void)getResultWithParameter:(NSDictionary *)parameter url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/** POST请求 */
-(void)postResultWithParameter:(NSDictionary *)parameter url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/** POST请求上传图片 */
-(void)upImageWithParameter:(NSDictionary *)parameter imageArray:(NSArray *)images url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/** 判断网络类型 */
+ (NetworkStates)getNetworkStates;

@end
