
//
//  BuyCountView.m
//  AddShoppingCart
//
//  Created by 主用户 on 16/3/23.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import "BuyCountView.h"

@implementation BuyCountView
@synthesize bt_add,bt_reduce,lb_count;
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 1;
        self.layer.borderColor = YHRGBA(164, 164, 164, 1.0).CGColor;
        
        bt_add= [UIButton buttonWithType:UIButtonTypeCustom];
        bt_add.frame = CGRectMake(self.width - 41, 1,40, 30);
        [bt_add setBackgroundColor:YHRGBA(255, 255, 255, 1.0)];
        
        [bt_add setTitleColor:[UIColor blackColor] forState:0];
        bt_add.titleLabel.font = [UIFont systemFontOfSize:20];
        [bt_add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [bt_add setTitle:@"+" forState:0];
        
        bt_add.eventTimeInterval = 0.5;
        
        [self addSubview:bt_add];
        
        UILabel *twoLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(bt_add.left -1, 1, 1, self.height)];
        twoLineLabel.backgroundColor = YHRGBA(164, 164, 164, 1.0);
        [self addSubview:twoLineLabel];
        
        lb_count = [[UILabel alloc] initWithFrame:CGRectMake(bt_add.left -41, 1, 40, 30)];
        lb_count.text = @"1";
        lb_count.textAlignment = NSTextAlignmentCenter;
        lb_count.font = [UIFont systemFontOfSize:15];
        lb_count.backgroundColor = [UIColor whiteColor];
        [self addSubview:lb_count];
        
        UILabel *threeLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(lb_count.left -1, 1, 1, self.height)];
        threeLineLabel.backgroundColor = YHRGBA(164, 164, 164, 1.0);
        [self addSubview:threeLineLabel];
        
        bt_reduce= [UIButton buttonWithType:UIButtonTypeCustom];
        bt_reduce.frame = CGRectMake(lb_count.left -41, 1, 40, 30);
        [bt_reduce setBackgroundColor:[UIColor whiteColor]];
        [bt_reduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
        bt_reduce.titleLabel.font = [UIFont systemFontOfSize:20];
        [bt_reduce setTitle:@"-" forState:0];
        bt_reduce.eventTimeInterval = 0.5;

        [bt_reduce setTitleColor:YHRGBA(231, 231, 231, 1.0) forState:0];
        [self addSubview:bt_reduce];
    }
    return self;
}

-(void)add
{
    int count =[lb_count.text intValue];

    if (count >= 1) {
        [bt_reduce setTitleColor:[UIColor blackColor] forState:0];
        
        lb_count.text = [NSString stringWithFormat:@"%d",count+1];
        
        if (_countChangeClickBlock) {
            _countChangeClickBlock(lb_count.text);
        }
    }
}

-(void)reduce
{
    int count =[lb_count.text intValue];
    
    if (count > 1) {
     
        if (count <= 2)
        {
            [bt_reduce setTitleColor:YHRGBA(231, 231, 231, 1.0) forState:0];
        }else
        {
            [bt_reduce setTitleColor:[UIColor blackColor] forState:0];
        }
        
        lb_count.text = [NSString stringWithFormat:@"%d",count-1];
        
        if (_countChangeClickBlock) {
            _countChangeClickBlock(lb_count.text);
        }
    }
}


@end
