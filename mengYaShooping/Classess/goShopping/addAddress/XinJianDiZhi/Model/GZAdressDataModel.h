//
//  GZAdressDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/23.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GZAdressDataModel <NSObject>

@end

@interface GZAdressDataModel : JSONModel

@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *area_name;
@property (nonatomic, copy) NSString *area_yunfei;

@end
