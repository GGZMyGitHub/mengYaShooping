//
//  GZfinishDataModel.h
//  mengYaShooping
//
//  Created by apple on 17/5/25.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZproListModel.h"

@interface GZfinishDataModel : JSONModel

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *creat_time;
@property (nonatomic, copy) NSString *fahuo_time;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *person;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *shouhuo_time;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *use_jifen;
@property (nonatomic, copy) NSString *yunfei;
@property (nonatomic, copy) NSString *order_states;

@property (nonatomic, strong) NSArray<GZproListModel,Optional> *pro_list;

@end
