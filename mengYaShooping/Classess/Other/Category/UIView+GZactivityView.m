//
//  UIView+GZactivityView.m
//  test
//
//  Created by apple on 17/6/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "UIView+GZactivityView.h"
#import <objc/runtime.h>
static char activityViewKey;

@implementation UIView (GZactivityView)

- (void)appendActivityView:(UIColor *)color{
    //1.添加菊花
    self.backgroundColor = YHRGBA(255, 255, 255, 0);
   // if (!self.appendActivity) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = self.bounds;
        activityIndicator.color = color;
        [activityIndicator startAnimating];
        [activityIndicator setHidesWhenStopped:YES];
        
        self.appendActivity = activityIndicator;
        
        //隐藏其它子视图
        for (UIView *view in self.subviews) {
            view.hidden = YES;
        }
        
        [self addSubview:activityIndicator];
  //  }
    
    [self bringSubviewToFront:self.appendActivity];
    
    //2.如果是scrollView，则在显示菊花时禁止滑动
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = NO;
    }
}

- (void)removeActivityView{
    //1.恢复滑动
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = YES;
    }
    
    for (UIView *view in self.subviews) {
        view.hidden = NO;
    }
    
    //2.去掉菊花
    if (self.appendActivity) {
        self.appendActivity.hidden = YES;
        [self.appendActivity stopAnimating]; // 结束旋转
        [self.appendActivity removeFromSuperview];
    }
}


#pragma mark - 运行时添加属性
- (UIActivityIndicatorView *)appendActivity{
    return objc_getAssociatedObject(self, &activityViewKey);
}

- (void)setAppendActivity:(UIActivityIndicatorView *)appendActivity{
    objc_setAssociatedObject(self, &activityViewKey, appendActivity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
