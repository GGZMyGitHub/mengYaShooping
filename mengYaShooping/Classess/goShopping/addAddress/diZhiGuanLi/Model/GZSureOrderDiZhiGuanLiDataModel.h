//
//  GZSureOrderDiZhiGuanLiDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/23.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZSureOrderDiZhiGuanLiDataModel <NSObject>

@end

@interface GZSureOrderDiZhiGuanLiDataModel : JSONModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *sureOrderDiZhiGuanLiID;
@property (nonatomic, copy) NSString *ismoren;
@property (nonatomic, copy) NSString *person;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *youfei;


/**
 判断是否是默认地址
 */
@property (nonatomic, assign) BOOL isDefaultAddress;

@end
