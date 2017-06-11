//
//  GZregisterNegotiateViewController.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/5.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "GZregisterNegotiateViewController.h"

@interface GZregisterNegotiateViewController ()

@end

@implementation GZregisterNegotiateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [MBProgressHUD showMessage:@"加载中..."];
    
    [self getData];
}

- (void)getData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
