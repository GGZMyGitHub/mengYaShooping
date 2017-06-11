//
//  GZSureOrderDiZhiGuanLiResuleModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/23.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZSureOrderDiZhiGuanLiDataModel.h"

@interface GZSureOrderDiZhiGuanLiResuleModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<GZSureOrderDiZhiGuanLiDataModel,Optional> *data;

@end
