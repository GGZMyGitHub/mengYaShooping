//
//  GZOrderDetailHeader.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/8.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZOrderDetailDataModel.h"
#import "BuyCountView.h"

@interface GZOrderDetailHeader : UIView

typedef void(^addShoppCycleScrollClick)(NSString *);
typedef void(^NoClassDataChangeCountNumberClick)(NSString *);
typedef void(^collectBtnClick)(BOOL,UIButton *);


@property (nonatomic, strong) GZOrderDetailDataModel *dataModel;

/** 点击轮播图回调 */
@property (nonatomic, copy) addShoppCycleScrollClick addShoppSelectCycleScrollBlock;

/**
 数量的变化 */
@property (nonatomic, copy) NoClassDataChangeCountNumberClick NoClassDataChangeCountNumberBlock;

/**
 点击收藏按钮的回调
 */
@property (nonatomic, copy) collectBtnClick collectBtnClickBlock;

/** 数量View */
@property (nonatomic, strong) BuyCountView *buyCountView;

@property (weak, nonatomic) IBOutlet UILabel *countPlace;
@property (weak, nonatomic) IBOutlet UILabel *shoppingPlace;


+ (instancetype)createCycleView;

@end
