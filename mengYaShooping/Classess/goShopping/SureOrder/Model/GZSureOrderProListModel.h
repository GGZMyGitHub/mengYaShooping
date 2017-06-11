//
//  GZSureOrderProListModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZSureOrderProListModel <NSObject>

@end

@interface GZSureOrderProListModel : JSONModel

@property (nonatomic, copy) NSString *P_count;
@property (nonatomic, copy) NSString *P_diyid;
@property (nonatomic, copy) NSString *P_diyname;
@property (nonatomic, copy) NSString *P_id;
@property (nonatomic, copy) NSString *P_logo;
@property (nonatomic, copy) NSString *P_name;
@property (nonatomic, copy) NSString *P_price;
@property (nonatomic, copy) NSString *P_price_shui;
@property (nonatomic, copy) NSString *c_id;

@end
