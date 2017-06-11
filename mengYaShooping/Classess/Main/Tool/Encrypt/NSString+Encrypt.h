//
//  NSString+Encrypt.h
//  DES
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

/**************  两层MD5，一层DES加密  ****************/

#import <Foundation/Foundation.h>

typedef enum
{
    MD532UpCode=0,//32位大写
    MD516UpCode,//16位大写
    MD532LowCode,//32位小写
   MD516LowCode,//16位小写
    
} MD5Type;

typedef NS_OPTIONS(NSUInteger, MD5StringLength8Site) {
    MD5StringLength8SiteLeft=0,//前8位
    MD5StringLength8SiteCenter ,//中间8位
    MD5StringLength8SiteRigth,//后8位
    MD5StringLength8SiteCustom//自定义8位
};
#define Length8    8
@interface NSString(Encrypt)
+ (NSString *)encryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv;//加密
+ (NSString *)decryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv;//解密
#pragma mark - MD5加密
/**
 *MD5加密
 */
-(NSString *)md5ForType:(MD5Type)type;
#pragma mark - 根据位置获取8位字符串
/**
 *根据位置获取8位字符串
 *随机的位置
 *只有自定义位置的时候才用到位置数组，否则的话位置数组无效
 */
-(NSString *)getLength8KeyFor:(MD5StringLength8Site)site BySiteArray:(NSArray *)siteArr;

#pragma mark - 三层加密
/**
 *获取DES加密的key
 */
-(NSString *)getDesEncryptKeyForTimeInterval:(NSString *)timeInterval Appkey:(NSString *)appkey;
/**
 *  获取DES加密的iv
 */
-(NSString *)getDesEncryptIVForTimeInterval:(NSString *)timeInterval AppSecret:(NSString *)appsecret;
/**
 *  DES加密
 */
-(NSString *)Des_EncryptForKey:(NSString *)key Iv:(NSString *)iv;//加密
/**
 *  解密
 */
-(NSString *)Des_DecryptForKey:(NSString *)key Iv:(NSString *)iv;
/**
 *  三层加密
 */
-(NSString *)Des_3EncryptForTimeInterval:(NSString *)timeInterval Appkey:(NSString *)appkey AppSecret:(NSString *)appsecret;
/**
 *  三层解密
 */
-(NSString *)Des_3DecryptForTimeInterval:(NSString *)timeInterval Appkey:(NSString *)appkey AppSecret:(NSString *)appsecret;
@end
