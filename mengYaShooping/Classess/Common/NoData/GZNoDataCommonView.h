//
//  GZNoDataCommonView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/6.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZNoDataCommonView : UIView

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

+ (instancetype)createNoDataCommonView;

@end
