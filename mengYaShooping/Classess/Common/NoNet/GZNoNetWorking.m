//
//  GZNoNetWorking.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/31.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZNoNetWorking.h"

@implementation GZNoNetWorking

+ (instancetype)createNoNetWorkingView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NoNetWorkingView" owner:nil options:nil] lastObject];
}

- (IBAction)agin:(UIButton *)sender {
    if (_netWorkAgainBlock) {
        _netWorkAgainBlock();
    }
}


@end
