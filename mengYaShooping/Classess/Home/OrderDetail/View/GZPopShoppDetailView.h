//
//  GZPopShoppDetailView.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/6.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyCountView.h"
#import "GZOrderDetailDataModel.h"
#import "GZHomeDetailProlistModel.h"

typedef void(^classClick)(NSString *);
typedef void(^countClick)(NSString *);
typedef void(^sureClick)();
typedef void(^carBtnClick)();

@interface GZPopShoppDetailView : UIView <UITextFieldDelegate,UIAlertViewDelegate>

/** 点击分类按钮回传classid */
@property (nonatomic, copy) classClick classClickBlock;

/** 确定按钮回调 */
@property (nonatomic, copy) sureClick sureClickBlock;

/** 数量 */
@property (nonatomic, copy) countClick countClickBlock;

/** 购物车按钮的回调 */
@property (nonatomic, copy) carBtnClick carBtnClickBlock;

@property(nonatomic, retain)UIView *alphaiView;
@property(nonatomic, retain)UIView *whiteView;

@property(nonatomic, retain)UIButton *bt_sure;
@property(nonatomic, retain)UIButton *bt_cancle;

@property (nonatomic, strong) BuyCountView *buyCountView;

/** 订单界面数据 */
@property (nonatomic, strong) GZOrderDetailDataModel *dataModel;

@property (nonatomic, strong) GGZButton *addShoppCarBtn;

/** 改变button颜色选中button */
@property (nonatomic, strong) UIButton *selectBtn;

@end
