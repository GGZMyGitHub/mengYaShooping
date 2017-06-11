//
//  GZCollectionResultModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZColletcionDataModel.h"

@interface GZCollectionResultModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSArray<GZColletcionDataModel,Optional>*data;

@end
