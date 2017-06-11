//
//  UIImage+GZExtension.h
//  youYouJiaJiao
//
//  Created by apple on 17/4/9.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYCropImageStyle){
    XYCropImageStyleRight        =0,   // 右半部分
    XYCropImageStyleCenter       =1,   // 中间部分
    XYCropImageStyleLeft        =2,   // 左半部分
    XYCropImageStyleRightOneOfThird   =3,   // 右侧三分之一部分
    XYCropImageStyleCenterOneOfThird  =4,   // 中间三分之一部分
    XYCropImageStyleLeftOneOfThird   =5,   // 左侧三分之一部分
    XYCropImageStyleRightQuarter    =6,   // 右侧四分之一部分
    XYCropImageStyleCenterRightQuarter =7,   // 中间右侧四分之一部分
    XYCropImageStyleCenterLeftQuarter  =8,   // 中间左侧四分之一部分
    XYCropImageStyleLeftQuarter     =9,   // 左侧四分之一部分
};

@interface UIImage (GZExtension)


+ (UIImage *)imageResizableNamed:(NSString *)name;

+ (UIImage *)imageWatermarkNamed:(NSString *)watermarkName named:(NSString *)name scale:(CGFloat)scale;

+ (UIImage *)imageRoundNamed:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (UIImage *)imageCaptureWithView:(UIView *)view;

/** 将颜色转化为UIImage */
+ (UIImage *)imageWithColores:(UIColor *)color;

- (UIColor *)pixelColorAtLocation:(CGPoint)point;

/**
 将颜色转化为UIImage，并设置大小
 */
+ (UIImage*)imageWithColor:(UIColor *)color forSize:(CGSize)size;


/**
 等比缩放图片大小

 */
+ (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size;


/**
 裁剪UIImage
 
 */
- (UIImage *)imageByCroppingWithStyle:(XYCropImageStyle)style;


+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

@end
