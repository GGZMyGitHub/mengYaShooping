//
//  GZCustomTextField.m
//  youYouJiaJiao
//
//  Created by apple on 17/4/10.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZCustomTextField.h"

@implementation GZCustomTextField

-(instancetype)initWithFrame:(CGRect)frame Icon:(UIImageView*)icon
{
  
    self = [super initWithFrame:frame];
    
    if (self) {
        self.leftView = icon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

/** 重写leftView方法 */
-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    iconRect.origin.y -= 2; //上偏5；
    
    return iconRect;
}

/** 重写placeholder方法 */
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super placeholderRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    iconRect.origin.y += 3; //下偏5；

    return iconRect;
}

@end
