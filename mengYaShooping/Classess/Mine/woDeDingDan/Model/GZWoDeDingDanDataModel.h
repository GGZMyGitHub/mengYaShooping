//
//  GZWoDeDingDanDataModel.h
//  mengYaShooping
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZWoDeDingDanListModel.h"

@protocol GZWoDeDingDanDataModel <NSObject>

@end

@interface GZWoDeDingDanDataModel : JSONModel

@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_states;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *yunfei;
@property (nonatomic, strong) NSArray<GZWoDeDingDanListModel,Optional> *zi_dic_list;

@end
