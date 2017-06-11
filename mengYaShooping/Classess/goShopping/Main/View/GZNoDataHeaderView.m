//
//  GZNoDataHeaderView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/19.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZNoDataHeaderView.h"


@interface GZNoDataHeaderView ()

- (IBAction)gotoHomeVC:(id)sender;

@end

@implementation GZNoDataHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setGotoHomeBtn:(GGZButton *)gotoHomeBtn
{
    _gotoHomeBtn = gotoHomeBtn;
    
    gotoHomeBtn.layer.masksToBounds = YES;
    gotoHomeBtn.layer.borderWidth = 1;
    gotoHomeBtn.layer.borderColor = YHRGBA(229, 78, 57, 1.0).CGColor;
    gotoHomeBtn.layer.cornerRadius = 3;
}

- (IBAction)gotoHomeVC:(id)sender {
    //发送通知，转换成首页界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoDataView" object:nil userInfo:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"NoDataView"];
}

@end
