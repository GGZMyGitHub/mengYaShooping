//
//  GZHomeViewController.h
//  mengYaShooping
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZBaseViewController.h"

typedef void(^selectHomeClassClick)(NSInteger);

@interface GZHomeViewController : GZBaseViewController

@property (nonatomic, strong) selectHomeClassClick selectHomeBolck;

@end
