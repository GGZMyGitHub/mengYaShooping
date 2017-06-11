//
//  GGZButton.m
//  tinkleChat
//
//  Created by lishu tech on 16/5/5.
//  Copyright © 2016年 GGZ. All rights reserved.
//

#import "GGZButton.h"

@implementation GGZButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
    
}

- (void)Click:(GGZButton *)button {
    if (_block) {
        _block(button);
    }
}

+ (instancetype)createGGZButton {
    
    return [GGZButton buttonWithType:UIButtonTypeCustom];
}

+ (UIButton *)setBasicAttribute:(UIButton *)button {
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2;
    button.layer.borderColor=YHRGBA(116, 124, 126, 1.0).CGColor;
    return button;
}

@end
