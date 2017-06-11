//
//  GZNoNetWorking.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/31.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^netWorkAgain)();

@interface GZNoNetWorking : UIView

+ (instancetype)createNoNetWorkingView;
@property (nonatomic, strong) netWorkAgain netWorkAgainBlock;

@end
