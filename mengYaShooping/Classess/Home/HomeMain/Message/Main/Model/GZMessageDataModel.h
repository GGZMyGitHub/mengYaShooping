//
//  GZMessageDataModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/10.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GZMessageListModel.h"

@interface GZMessageDataModel : JSONModel

@property (nonatomic, copy) NSString *jifen_no_read;
@property (nonatomic, copy) NSString *order_no_read;
@property (nonatomic, copy) NSString *xitong_no_read;
@property (nonatomic, strong) NSArray <GZMessageListModel,Optional> *list;


@end
