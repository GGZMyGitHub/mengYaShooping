//
//  GZStatusView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZStatusView.h"

@implementation GZStatusView

+ (instancetype)createOrderStatusView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"statusView" owner:nil options:nil] lastObject];
}

- (IBAction)daiFaHuo:(UIButton *)sender {
    
    if (_daiFaHuoClickBlock) {
        _daiFaHuoClickBlock(@"0");
    }
}

- (IBAction)daiShouHuo:(UIButton *)sender {
    if (_daiShouHuoClickBlock) {
        _daiShouHuoClickBlock(@"1");
    }
    
}
- (IBAction)yiWanCheng:(UIButton *)sender {
    if (_yiWanChengClickBlock) {
        _yiWanChengClickBlock(@"2");
    }
}



@end
