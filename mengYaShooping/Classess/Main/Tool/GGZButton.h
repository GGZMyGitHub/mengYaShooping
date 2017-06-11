//
//  GGZButton.h
//  tinkleChat
//
//  Created by lishu tech on 16/5/5.
//  Copyright © 2016年 GGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGZButton;

typedef void(^GGZButtonClick)(GGZButton *);

@interface GGZButton : UIButton

//block回调
@property (nonatomic,copy)GGZButtonClick block;

+ (instancetype)createGGZButton;

//圆角属性
+ (UIButton *)setBasicAttribute:(UIButton *)button;

@end
