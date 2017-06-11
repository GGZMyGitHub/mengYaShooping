//
//  GZWoDeJiFenDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZWoDeJiFenListModel.h"

@interface GZWoDeJiFenDataModel : JSONModel

@property (nonatomic, copy) NSString *allcount;
@property (nonatomic, strong) NSArray <GZWoDeJiFenListModel,Optional> *list;

@end
