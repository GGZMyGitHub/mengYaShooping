//
//  UIView+GZactivityView.h
//  test
//
//  Created by apple on 17/6/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GZactivityView)

/**
 附加菊花图
 */
@property (nonatomic,strong) UIActivityIndicatorView *appendActivity;

- (void)appendActivityView:(UIColor *)color;

/**
 移除菊花
 */
- (void)removeActivityView;


@end
