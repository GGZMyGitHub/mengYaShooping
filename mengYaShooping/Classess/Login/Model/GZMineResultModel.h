//
//  GZMineResultModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/25.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZMineResultModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSDictionary *data;

@end