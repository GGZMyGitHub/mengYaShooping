//
//  GZLoginViewController.h
//  mengYaShooping
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectTabBar)();

@interface GZLoginViewController : UIViewController

@property (nonatomic, strong) selectTabBar selectTabBarBlock;

@property (nonatomic, copy) NSString *languageID;

@end
