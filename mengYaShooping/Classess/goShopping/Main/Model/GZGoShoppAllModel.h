//
//  GZGoShoppAllModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/6/1.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZGoShoppAllModel <NSObject>

@end

@interface GZGoShoppAllModel : JSONModel

@property (nonatomic, copy) NSString *C_id;
@property (nonatomic, copy) NSString *P_id;
@property (nonatomic, copy) NSString *P_name;
@property (nonatomic, copy) NSString *P_price;
@property (nonatomic, copy) NSString *P_logo;
@property (nonatomic) NSInteger P_count;
@property (nonatomic, copy) NSString *diy_name;


@property (nonatomic) NSInteger totalPrice;


/**
 自己设置，设置选中与未选中的状态，避免cell重用
 */
@property (nonatomic, assign) BOOL status;

@end
