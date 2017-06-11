//
//  GZMessageResultModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/10.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZMessageResultModel : JSONModel

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, strong) NSDictionary <Optional> *data;


@end
