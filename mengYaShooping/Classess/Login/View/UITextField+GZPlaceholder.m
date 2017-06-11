//
//  UITextField+GZPlaceholder.m
//  mengYaShooping
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "UITextField+GZPlaceholder.h"
#import <objc/message.h>

@implementation UITextField (GZPlaceholder)

+ (void)load
{
    // setPlaceholder
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setlp_PlaceholderMethod = class_getInstanceMethod(self, @selector(setlp_Placeholder:));
    
    method_exchangeImplementations(setPlaceholderMethod, setlp_PlaceholderMethod);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}


- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

// 设置占位文字
// 设置占位文字颜色
- (void)setlp_Placeholder:(NSString *)placeholder
{
    [self setlp_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}

@end
