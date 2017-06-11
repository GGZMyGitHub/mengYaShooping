//
//  GZAddressViewController.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/22.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZSureOrderDiZhiGuanLiDataModel.h"

@interface GZAddressViewController : UIViewController

/**
 地址ID
 */
@property (nonatomic, copy) NSString *adressID;

/** 修改地址时用 */
@property (nonatomic, copy) GZSureOrderDiZhiGuanLiDataModel *dataModel;

@end

