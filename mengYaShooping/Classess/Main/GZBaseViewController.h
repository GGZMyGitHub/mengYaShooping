//
//  GZBaseViewController.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZBaseViewController : UIViewController

@property (nonatomic, strong) UIBarButtonItem *messageBtn;

//消息红点
@property (nonatomic, strong) UILabel *redSpotLabel;

- (void)messageClick:(UIButton *)btn;


@end
