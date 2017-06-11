//
//  GZfinishOrderFooterView.h
//  mengYaShooping
//
//  Created by apple on 17/5/26.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZfinishDataModel.h"

typedef void(^payForAgainClick)();

@interface GZfinishOrderFooterView : UIView

/** 点击再次购买的回调 */
@property (nonatomic, copy) payForAgainClick payForAgainClickBlock;

@property (nonatomic, strong) GZfinishDataModel *dataModel;

@property (weak, nonatomic) IBOutlet UIButton *payforBtn;

@property (weak, nonatomic) IBOutlet UILabel *fukuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *fahuoLabel;

@property (weak, nonatomic) IBOutlet UILabel *fixedFuKuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *fixedFaHuoLabel;


+ (instancetype)sharedSureOrderHeaderView;

@end
