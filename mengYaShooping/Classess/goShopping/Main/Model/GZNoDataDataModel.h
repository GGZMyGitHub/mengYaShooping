//
//  GZNoDataDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/19.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZNoDataProlist.h"

@interface GZNoDataDataModel : JSONModel

@property (nonatomic, strong) NSArray<GZNoDataProlist,Optional>*prolist;

@end
