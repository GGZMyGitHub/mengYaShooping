//
//  GZDataHomeModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/3.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZAdlistModel.h"
#import "GZClassListModel.h"
#import "GZHotListModel.h"

@interface GZDataHomeModel : JSONModel

@property (nonatomic, copy) NSString *no_read;

@property (nonatomic, strong) NSArray <GZAdlistModel,Optional> *adlist;
@property (nonatomic, strong) NSArray <GZClassListModel,Optional> *class_list;
@property (nonatomic, strong) NSArray <GZHotListModel,Optional> *hotlist;

@end
