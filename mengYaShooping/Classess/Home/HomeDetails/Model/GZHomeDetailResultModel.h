//
//  GZHomeDetailResultModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/4.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZHomeDetailResultModel : JSONModel

@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSDictionary *data;

@end
