//
//  AppDelegate+GZRootViewController.m
//  mengYaShooping
//
//  Created by apple on 17/4/15.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import "AppDelegate+GZRootViewController.h"
#import "GZTabBarViewController.h"
#import "GZGuideViewController.h"
#import "GZChooseLanguageController.h"

@implementation AppDelegate (GZRootViewController)

-(void)createLoadingScrollView
{
    /**
     每次都走选择语言界面，当语言选择过之后，再不走这个界面
     **/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *islanguage = [defaults objectForKey:@"languageID"];

    if ([islanguage isEqualToString:@"0"] || [islanguage isEqualToString:@"1"] ||[islanguage isEqualToString:@"2"]) {
        
        GZTabBarViewController *tab = [[GZTabBarViewController alloc] init];
        self.window.rootViewController = tab;

    }else
    {
        GZChooseLanguageController *chooseLanguageVC = [[GZChooseLanguageController alloc] init];
        
        self.window.rootViewController = chooseLanguageVC;
    }
}

@end
