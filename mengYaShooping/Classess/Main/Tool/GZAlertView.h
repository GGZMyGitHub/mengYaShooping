//
//  GZAlertView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GZAlertViewSureBlock)(NSString *);

@interface GZAlertView : UIView

@property(nonatomic ,strong )GZAlertViewSureBlock block;

+ (instancetype)sharedAlertView;

//修改字体颜色的大小

@property(nonatomic)CGFloat messageSize;
@property(nonatomic)CGFloat cancelSize;
@property(nonatomic)CGFloat sureSize;
@property(nonatomic)UIColor * messageColor;
@property(nonatomic)UIColor * sureColor;
@property(nonatomic)UIColor * cancelColor;
@property(nonatomic)UIColor * sureBackColor;
@property(nonatomic)UIColor * cancelBackColor;



/**
 显示Alert，可随意定制Image
 */
- (void)alertViewMessage :(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle image:(NSString *)image Block:(GZAlertViewSureBlock)block;

/**
 加载动画
 */
-(void)animationAlert;

@end
