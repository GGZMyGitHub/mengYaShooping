//
//  GZHttpTool.h
//  DongHeng
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "GZCacheTool.h"

@interface GZCache : NSObject

@property (nonatomic, copy) NSString *fileName;//缓存文件名
@property (nonatomic, assign) BOOL result;//是否需要重新请求数据

@end


@interface NSError (GZHttp)
/**HTTP请求的状态码*/
@property (nonatomic, assign) NSInteger statusCode;

@end

@interface GZHttpTool : NSObject


/**
 get请求,不缓存
 
 @param url 请求的API地址
 @param params 参数
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 get请求,设置缓存类型
 
 @param url 请求的API地址
 @param params 参数
 @param cacheType YBCacheType
 
 YBCacheTypeReturnCacheDataThenLoad = 0,///< 有缓存就先返回缓存，同步请求数据
 YBCacheTypeReloadIgnoringLocalCacheData, ///< 忽略缓存，重新请求
 YBCacheTypeReturnCacheDataElseLoad,///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
 YBCacheTypeReturnCacheDataDontLoad,///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
 YBCacheTypeReturnCacheDataExpireThenLoad///< 有缓存就用缓存，如果过期了就重新请求 没过期就不请求
 
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params cacheType:(GZCacheType)cacheType success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;


/**
 post请求，不缓存
 
 @param url 请求的API地址
 @param params 参数
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 post请求
 
 @param url 请求的API地址
 @param params 参数
 @param cacheType YBCacheType
 
 YBCacheTypeReturnCacheDataThenLoad = 0,///< 有缓存就先返回缓存，同步请求数据
 YBCacheTypeReloadIgnoringLocalCacheData, ///< 忽略缓存，重新请求
 YBCacheTypeReturnCacheDataElseLoad,///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
 YBCacheTypeReturnCacheDataDontLoad,///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
 YBCacheTypeReturnCacheDataExpireThenLoad///< 有缓存就用缓存，如果过期了就重新请求 没过期就不请求
 
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params cacheType:(GZCacheType)cacheType success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 上传单张图片
 
 @param image 图片二进制数据
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)uploadImageWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params  success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 上传多张图片
 
 @param images 图片二进制数组
 @param success 成功回调Block
 @param failure 失败回调Block
 */
+ (void)uploadImageArrayWithImages:(NSArray<NSData *> *)images URLStr:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *error))failure;

/**
 通过time、appkey和appSecret进行加密
 */
+ (NSString *)encryptAppkeyAndAppSecret:(NSString *)uid;

@end
