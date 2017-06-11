//
//  GZSureOrderDiZhiGuanLiCell.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/23.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZSureOrderDiZhiGuanLiDataModel.h"

typedef void(^defaultBtnClick)();
typedef void(^deleteBtnClick)();
typedef void(^alterBtnClick)();


@interface GZSureOrderDiZhiGuanLiCell : UITableViewCell

/** 设置默认地址回调 */
@property (nonatomic, copy) defaultBtnClick defaultBtnClickBlock;

/** 删除按钮回调 */
@property (nonatomic, copy) deleteBtnClick deleteBtnClickBlock;

/** 修改按钮回调 */
@property (nonatomic, copy) alterBtnClick alterBtnClickBlock;


@property (nonatomic, strong) GZSureOrderDiZhiGuanLiDataModel *dataModel;

@end
