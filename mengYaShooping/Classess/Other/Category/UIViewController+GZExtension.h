//
//  UIViewController+GZExtension.h
//  youYouJiaJiao
//
//  Created by apple on 17/4/9.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGZButton.h"
#import "GZCustomTextField.h"

@interface UIViewController (GZExtension)

/**
 导航栏渐变
 
 @param scrollView 继承自UIScrollView都可以，可以传UITableView
 @param offset 上拉偏移量
 @param color 最终的颜色
 */
- (void)navigationBarGradualChangeWithScrollView:(UIScrollView *)scrollView positionBtn:(GGZButton *)positionBtn newsBtn:(GGZButton *)newsBtn GZCustomTextField:(GZCustomTextField *)searchTF offset:(CGFloat)offset color:(UIColor *)color;


/**
 修改导航栏颜色
 
 @param color 颜色
 @param alpha 透明度
 */
- (void)setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha;

@end
