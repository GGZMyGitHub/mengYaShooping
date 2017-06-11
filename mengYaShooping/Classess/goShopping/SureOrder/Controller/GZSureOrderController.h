//
//  GZSureOrderController.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZSureOrderDataModel.h"

#import "GZSureOrderDiZhiGuanLiDataModel.h"

@interface GZSureOrderController : UIViewController


/**
 将选中的购物车ID传过来，等选择完地址的时候再次刷新。
 */
@property (nonatomic, copy) NSString *totoalCarID;

/** 数据源 */
@property (nonatomic, strong) GZSureOrderDataModel *dataModel;

@end
