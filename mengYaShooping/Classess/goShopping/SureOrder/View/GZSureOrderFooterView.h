//
//  GZSureOrderFooterView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/21.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZSureOrderDataModel.h"

typedef void(^discountClick)(BOOL);
typedef void(^problemClick)();

@interface GZSureOrderFooterView : UIView

/** 勾选折扣回调 */
@property (nonatomic, copy) discountClick discountClickBlock;

/** 点击使用积分按钮回调 */
@property (nonatomic, copy) problemClick problemClickBlock;

@property (nonatomic, strong) GZSureOrderDataModel *dataModel;

@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;

+ (instancetype)sharedSureOrderFooterView;

@end
