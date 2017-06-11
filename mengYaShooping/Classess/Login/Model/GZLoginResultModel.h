//
//  GZLoginResultModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/26.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZLoginResultModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSDictionary *data;

@end
