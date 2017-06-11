//
//  GZOrderDetailDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/8.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZOrderDetailDataModel : JSONModel

@property (nonatomic, copy) NSString *p_price;
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *p_info;
@property (nonatomic, copy) NSString *p_id;
@property (nonatomic, copy) NSString *p_head;
@property (nonatomic, copy) NSString *isjifen_dikou;
@property (nonatomic, copy) NSString *isjifen_back;
@property (nonatomic, copy) NSString *C_Is_shoucang;
@property (nonatomic, copy) NSString *C_id;
@property (nonatomic, strong) NSArray *diylist;
@property (nonatomic, strong) NSArray *p_logos;

@end
