//
//  GGZTool.h
//  Mirror
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年 GGZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};

@interface GGZTool : NSObject

/**
 正则表达式判断手机号格式是否正确
 */
+ (BOOL)valiMobile:(NSString *)mobile;

//判断手机型号（5、5c、5s、6、6s、6p∫）
+ (NSString *) iphoneType;

//获取系统星期
+ (NSString *) getSystemDate;

//上面数字和下面数字颜色字体大小的不同，返回label
+ (UILabel *)differentColorFrame:(CGRect) frame Label:(NSString *)titleFromSever title:(NSString *)title beforeColor:(UIColor *)beforeColor laterColor:(UIColor *)laterColor;


// 判断网络类型
+ (NetworkStates)getNetworkStates;

/** 压缩图片尺寸 */
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

/**
 图片模糊化
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

/** 选择的语言种类 */
+(NSString *)iSLanguageID;

/** 判断是否登录 */
+ (BOOL) iSSureLogin;

/** 登录成功之后的uid */
+ (NSString *) isUid;


/**
 判断是否含有非法字符

 @param content 用户名
 @return yes 有  no没有
 */
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;
@end
