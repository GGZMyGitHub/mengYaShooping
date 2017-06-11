//
//  GZHomeDetailDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/4.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZHomeDetailClassListModel.h"
#import "GZHomeDetailProlistModel.h"

@interface GZHomeDetailDataModel : JSONModel

@property (nonatomic, strong) NSArray<GZHomeDetailClassListModel,Optional> *class_list;
@property (nonatomic, strong) NSArray<GZHomeDetailProlistModel,Optional> *prolist;

@end
