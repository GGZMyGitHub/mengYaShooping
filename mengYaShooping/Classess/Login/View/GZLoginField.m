//
//  GZLoginField.m
//  mengYaShooping
//
//  Created by apple on 17/4/18.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZLoginField.h"
#import "UITextField+GZPlaceholder.h"

@implementation GZLoginField

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self steupField];
}
// 文本框开始编辑调用
- (void)textBegin{
    
    self.placeholderColor = YHRGBA(193, 193, 193, 1.0);
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
}

// 文本框结束编辑调用
- (void)textEnd{
    
    self.placeholderColor = YHRGBA(193, 193, 193, 1.0);
    
    //过滤特殊字符串
    if ([self.text isEmpty]) {
        
        UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
        placeholderLabel.textAlignment = NSTextAlignmentCenter;

        
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self steupField];
    }
    return self;
}

- (void)steupField{
    
    // 设置光标的颜色为白色
    self.tintColor = YHRGBA(193, 193, 193, 1.0);
    
    // 通知-->开始编辑的时候
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    // 通知-->编辑完成的时候
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    // 获取占位文字控件
    self.placeholderColor = YHRGBA(193, 193, 193, 1.0);
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
}

@end
