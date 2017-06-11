//
//  GZNoDataProlist.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/19.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZNoDataProlist <NSObject>

@end

@interface GZNoDataProlist : JSONModel

@property (nonatomic, copy) NSString *p_id;
@property (nonatomic, copy) NSString *P_head;
@property (nonatomic, copy) NSString *p_miaoshu;
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *p_price;
@property (nonatomic, copy) NSString *p_price_shui;

@end
