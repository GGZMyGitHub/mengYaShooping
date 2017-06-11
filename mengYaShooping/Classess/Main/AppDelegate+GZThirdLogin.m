//
//  AppDelegate+GZThirdLogin.m
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "AppDelegate+GZThirdLogin.h"

#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialConfig.h"

#define UmengAppkey @"53290df956240b6b4a0084b3"
@implementation AppDelegate (GZThirdLogin)

- (void)ThirdLogin
{
    
    [UMSocialData setAppKey:UmengAppkey];

    [UMSocialWechatHandler setWXAppId:@"wxe6b5b748cdcff60f" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.umeng.com/social"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104908293" appKey:@"MnGtpPN5AiB6MNvj" url:@"www.umeng.com/social"];
    

}

@end
