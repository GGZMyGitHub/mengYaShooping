//
//  NSString+Encrypt.m
//  DES
//
//  Created by apple on 15/4/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+Encrypt.h"
#import<CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(Encrypt)
+ (NSString *)encryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv
{
    //kCCEncrypt 加密
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:key ForInitIv:(NSString *)initIv];
}

+ (NSString *)decryptWithText:(NSString *)sText ForKey:(NSString *)key ForInitIv:(NSString *)initIv
{
    //kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:key ForInitIv:(NSString *)initIv];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key ForInitIv:(NSString *)initIv
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
       // NSData *decryptData = [NSData decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
       NSData *decryptData = [[NSData alloc]initWithBase64EncodedData:[sText dataUsingEncoding:NSUTF8StringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
   // NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        //result = [NSData stringByEncodingData:data];
          result = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    return result;
}
#pragma mark - MD5加密
/**
 *MD5加密
 */
-(NSString *)md5ForType:(MD5Type)type{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        if (type == MD516UpCode || type == MD532UpCode) {
             [ret appendFormat:@"%02X", result[i]];
        }else{
             [ret appendFormat:@"%02x", result[i]];
        }
    }
    
    return ret;
   /* NSArray *siteArr=@[@(1),@(2),@(3),@(5),@(7),@(8),@(9)];
    
   if (type == MD516UpCode || type ==MD516LowCode) {
       return [[ret substringWithRange:NSMakeRange(8, 16)] getLength8KeyFor:MD5StringLength8SiteCustom BySiteArray:siteArr];
    }
    return [ret getLength8KeyFor:MD5StringLength8SiteCustom BySiteArray:siteArr];*/
}
#pragma mark - 根据位置获取8位字符串
/**
 *根据位置获取8位字符串
 *随机的位置
 *只有自定义位置的时候才用到位置数组，否则的话位置数组无效
 */
-(NSString *)getLength8KeyFor:(MD5StringLength8Site)site BySiteArray:(NSArray *)siteArr{
    if (self.length<Length8) {
        return self;
    }else if (site == MD5StringLength8SiteCustom) {
        NSString *key=@"";
        const char *cStr = [self UTF8String];
        for (int i=0; i<siteArr.count; i++) {
            id site=[siteArr objectAtIndex:i];
            if ([site integerValue]<self.length) {
                key=[NSString stringWithFormat:@"%@%c",key,cStr[[site integerValue]]];
            }
        }
        return [NSString stringWithFormat:@"%@G",key];
    }else if(site == MD5StringLength8SiteLeft){
        return [self substringToIndex:Length8];
    }else if (site == MD5StringLength8SiteCenter){
         return [self substringWithRange:NSMakeRange(self.length/2-Length8/2, Length8)] ;
    }else{
         return [self substringFromIndex:self.length-Length8];
    }
}
#pragma mark - 三层加密
/**
 *  三层加密
 *获取DES加密的key
 */
-(NSString *)getDesEncryptKeyForTimeInterval:(NSString *)timeInterval Appkey:(NSString *)appkey{
    //对时间戳进行MD5 大写加密
    NSString *md5time=[timeInterval md5ForType:MD532UpCode];
    //获取前8位大写加密传与appkey拼接
    NSString *transtring=[NSString stringWithFormat:@"%@%@",[md5time getLength8KeyFor:MD5StringLength8SiteLeft BySiteArray:nil],appkey];
    //对拼接后的传进行MD5小写加密，并取中间8位,得到key
  //  NSLog(@"%@",[transtring md5ForType:MD532LowCode] );
    return [[transtring md5ForType:MD532LowCode] getLength8KeyFor:MD5StringLength8SiteCenter BySiteArray:nil];
    
}
/**
 *  获取DES加密的iv
 */
-(NSString *)getDesEncryptIVForTimeInterval:(NSString *)timeInterval AppSecret:(NSString *)appsecret{
    //对时间戳进行MD5 小写加密
    NSString *md5time=[timeInterval md5ForType:MD532LowCode];
    //获取中间8位小写加密传与appsecret拼接
    NSString *transtring=[NSString stringWithFormat:@"%@%@",[md5time getLength8KeyFor:MD5StringLength8SiteCenter BySiteArray:nil],appsecret];
    //对拼接后的传进行MD5大写加密，并取后8位,得到key
    //  NSLog(@"%@",[[transtring md5ForType:MD532UpCode] getLength8KeyFor:MD5StringLength8SiteRigth BySiteArray:nil]);
    return [[transtring md5ForType:MD532UpCode] getLength8KeyFor:MD5StringLength8SiteRigth BySiteArray:nil];
}
/**
 *  DES加密
 */
-(NSString *)Des_EncryptForKey:(NSString *)key Iv:(NSString *)iv{
    if (self) {
        return [NSString encryptWithText:self ForKey:key ForInitIv:iv];
    }
  return @"";
}
/**
 *  解密
 */
-(NSString *)Des_DecryptForKey:(NSString *)key Iv:(NSString *)iv{
    if (self) {
        return [NSString decryptWithText:self ForKey:key ForInitIv:iv];
    }
    return @"";
}
/**
 *  三层加密
 */
-(NSString *)Des_3EncryptForTimeInterval:(NSString *)timeInterval Appkey:(NSString *)appkey AppSecret:(NSString *)appsecret{
    return [self Des_EncryptForKey:[self getDesEncryptKeyForTimeInterval:timeInterval Appkey:appkey] Iv:[self getDesEncryptIVForTimeInterval:timeInterval AppSecret:appsecret]];
}
/**
 *  三层解密
 */
-(NSString *)Des_3DecryptForTimeInterval:(NSString *)timeInterval Appkey:(NSString *)appkey AppSecret:(NSString *)appsecret{
       return [self Des_DecryptForKey:[self getDesEncryptKeyForTimeInterval:timeInterval Appkey:appkey] Iv:[self getDesEncryptIVForTimeInterval:timeInterval AppSecret:appsecret]];
}
@end
