//
//  GZColletcionDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZColletcionDataModel <NSObject>

@end

@interface GZColletcionDataModel : JSONModel

@property (nonatomic, copy) NSString *C_id;
@property (nonatomic, copy) NSString *P_id;
@property (nonatomic, copy) NSString *p_img;
@property (nonatomic, copy) NSString *p_miaoshu;
@property (nonatomic, copy) NSString *p_name;
@property (nonatomic, copy) NSString *p_price;

@end
