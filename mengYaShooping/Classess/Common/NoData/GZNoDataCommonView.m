
//
//  GZNoDataCommonView.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/6.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZNoDataCommonView.h"

@implementation GZNoDataCommonView

+ (instancetype)createNoDataCommonView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"NoDataCommonView" owner:nil options:nil] lastObject];
}

@end
