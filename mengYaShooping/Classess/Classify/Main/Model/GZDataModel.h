//
//  GZDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/4/24.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZFirstModel.h"

@interface GZDataModel : JSONModel

@property (nonatomic, strong) NSArray <GZFirstModel,Optional>*one_dic_list;

@end
