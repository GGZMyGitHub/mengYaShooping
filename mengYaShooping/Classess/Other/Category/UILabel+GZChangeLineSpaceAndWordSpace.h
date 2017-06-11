//
//  UILabel+GZChangeLineSpaceAndWordSpace.h
//  youYouJiaJiao
//
//  Created by apple on 17/4/7.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (GZChangeLineSpaceAndWordSpace)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


/**
 UILabel宽度自适应

 @param title UILabel的宽度
 @param font 字体
 */
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
