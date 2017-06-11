//
//  GZWoDeDingDanResultModel.h
//  mengYaShooping
//
//  Created by apple on 17/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZWoDeDingDanDataModel.h"

@interface GZWoDeDingDanResultModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray <GZWoDeDingDanDataModel,Optional>*data;


@end
