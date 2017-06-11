//
//  GZHttpTool.m
//  DongHeng
//
//  Created by apple on 17/3/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZHttpTool.h"
#import <objc/runtime.h>

@implementation GZCache

@end

static char *NSErrorStatusCodeKey = "NSErrorStatusCodeKey";

@implementation NSError (GZHttp)

- (void)setStatusCode:(NSInteger)statusCode
{
    objc_setAssociatedObject(self, NSErrorStatusCodeKey, @(statusCode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)statusCode
{
    return [objc_getAssociatedObject(self, NSErrorStatusCodeKey) integerValue];
}

@end

@implementation GZHttpTool

//错误处理
+ (void)errorHandle:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error failure:(void (^)(NSError *))failure
{
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = response.statusCode;
    
    error.statusCode = statusCode;
    
    if (statusCode == 401) {//密码错误
        
    } else if (statusCode == 0) {//没有网络
        
    } else if (statusCode == 500) {//参数错误
        
    } else if (statusCode == 404) {
        
    } else if (statusCode == 400) {
        
    }
    
    if (failure) {
        failure(error);
    }
}

+ (NSString *)fileName:(NSString *)url params:(NSDictionary *)params
{
    NSMutableString *mStr = [NSMutableString stringWithString:url];
    if (params != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [mStr appendString:str];
    }
    return mStr;
}

+ (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置接受的类型
   // sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];

    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 30;
    //设置请求头  根据项目设置
    [sessionManager.requestSerializer setValue:@"ajSgfASewSsEhGdAsFf" forHTTPHeaderField:@"ticket"];
    return sessionManager;
}

+ (GZCache *)getCache:(GZCacheType)cacheType url:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success
{
    //缓存数据的文件名
    NSString *fileName = [self fileName:url params:params];
    NSData *data = [GZCacheTool getCacheFileName:fileName];
    
    GZCache *cache = [[GZCache alloc] init];
    cache.fileName = fileName;
    
    if (data.length) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (cacheType == GZCacheTypeReloadIgnoringLocalCacheData) {//忽略缓存，重新请求
            
        } else if (cacheType == GZCacheTypeReturnCacheDataDontLoad) {//有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
            
        } else if (cacheType == GZCacheTypeReturnCacheDataElseLoad) {//有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
            if (success) {
                success(dict);
            }
            cache.result = YES;
            
        } else if (cacheType == GZCacheTypeReturnCacheDataThenLoad) {///有缓存就先返回缓存，同步请求数据
            if (success) {
                success(dict);
            }
        } else if (cacheType == GZCacheTypeReturnCacheDataExpireThenLoad) {//有缓存 判断是否过期了没有 没有就返回缓存
            //判断是否过期
            if (![GZCacheTool isExpire:fileName]) {
                if (success) {
                    success(dict);
                }
                cache.result = YES;
            }
        }
    }
    return cache;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params cacheType:(GZCacheType)cacheType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    
    NSString *httpStr = [[kAPI_URL stringByAppendingString:url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //缓存数据的文件名 data
    if (cacheType == GZNoCache) {
        GZWeakSelf
        [sessionManager GET:httpStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            GZLog(@"%lld", downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf errorHandle:task error:error failure:failure];
        }];
    } else {
        
        GZCache *cache = [self getCache:cacheType url:url params:params success:success];
        NSString *fileName = cache.fileName;
        if (cache.result) return;
        
        GZWeakSelf
        [sessionManager GET:httpStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            GZLog(@"%lld", downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                
                //缓存数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                [GZCacheTool cacheForData:data fileName:fileName];
                
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf errorHandle:task error:error failure:failure];
        }];
    }
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self get:url params:params cacheType:GZNoCache success:success failure:failure];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params cacheType:(GZCacheType)cacheType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    sessionManager.requestSerializer.timeoutInterval = 20.0;
    
    NSString *httpStr = [[kAPI_URL stringByAppendingString:url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (cacheType == GZNoCache) {
        GZWeakSelf
        [sessionManager POST:httpStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [weakSelf errorHandle:task error:error failure:failure];
        }];

    } else {
        //缓存数据的文件名 data
        GZCache *cache = [self getCache:cacheType url:url params:params success:success];
        NSString *fileName = cache.fileName;
        if (cache.result) return;
        
        GZWeakSelf
        [sessionManager POST:httpStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                //缓存数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                [GZCacheTool cacheForData:data fileName:fileName];
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [weakSelf errorHandle:task error:error failure:failure];
        }];
    }
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self post:url params:params cacheType:GZNoCache success:success failure:failure];
}

+ (void)uploadImageWithImage:(UIImage *)image url:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    
    GZWeakSelf;
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image,0.4);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        
        //上传成功
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        
        //上传失败
        [weakSelf errorHandle:task error:error failure:failure];
    }];
}

+ (void)uploadImageArrayWithImages:(NSArray<NSData *> *)images URLStr:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [sessionManager.requestSerializer setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    
    //NSString *httpStr = [[kAPI_URL stringByAppendingString:@"pic/fileuploadArr"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *httpStr = [[url stringByAppendingString:@"pic/fileuploadArr"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    GZWeakSelf
    [sessionManager POST:httpStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //upfiles 是参数名 根据项目修改
            [formData appendPartWithFileData:obj name:@"refrence" fileName:[NSString stringWithFormat:@"%.0f.jpg", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [weakSelf errorHandle:task error:error failure:failure];
        }
    }];
}

+ (NSString *)encryptAppkeyAndAppSecret:(NSString *)uid
{
    NSString *time = [NSString stringWithFormat:@"%.0f",[ClockObject defaultClockObject].timeIntercal];
    
    NSString *appkey=@"142575354532";
    NSString *appSecret=@"726NlYPfpU2Sh6Fc646Bgg";
    NSString *encryptStr = [uid Des_3EncryptForTimeInterval:time Appkey:appkey AppSecret:appSecret];
    
    return encryptStr;
}

@end
