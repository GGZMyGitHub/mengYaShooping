//
//  GZSureOrderDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZSureOrderProListModel.h"

@interface GZSureOrderDataModel : JSONModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *all_wei_youhui;
@property (nonatomic, copy) NSString *get_jifen;
@property (nonatomic, copy) NSString *sureOrderID;
@property (nonatomic, copy) NSString *ishave;
@property (nonatomic, copy) NSString *ismoren;
@property (nonatomic, copy) NSString *person;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *use_jifen;
@property (nonatomic, copy) NSString *youfei;
@property (nonatomic, copy) NSString *use_mony;

@property (nonatomic, copy) NSArray <GZSureOrderProListModel,Optional>*pro_list;

@end
