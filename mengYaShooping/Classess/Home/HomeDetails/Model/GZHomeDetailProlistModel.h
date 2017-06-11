//
//  GZHomeDetailProlistModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/4.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZHomeDetailDiylistModel.h"

@protocol GZHomeDetailProlistModel <NSObject>

@end

@interface GZHomeDetailProlistModel : JSONModel

@property (nonatomic, copy) NSString *p_price_shui;
@property (nonatomic, copy) NSString *p_price;
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *p_miaoshu;
@property (nonatomic, copy) NSString *p_info;
@property (nonatomic, copy) NSString *p_id;
@property (nonatomic, copy) NSString *p_head;
@property (nonatomic, copy) NSString *isjifen_dikou;
@property (nonatomic, copy) NSString *isjifen_back;

@property (nonatomic, copy) NSArray <GZHomeDetailDiylistModel,Optional>*diylist;

@end
