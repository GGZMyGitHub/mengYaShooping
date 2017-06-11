//
//  GZWoDeJiFenResultModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/11.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZWoDeJiFenResultModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSDictionary <Optional> *data;

@end
