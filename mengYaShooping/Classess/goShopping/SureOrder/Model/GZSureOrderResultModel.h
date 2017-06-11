//
//  GZSureOrderResultModel.h
//  mengYaShooping
//
//  Created by guGuangZhou on 2017/5/20.
//  Copyright © 2017年 GuangZhou Gu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GZSureOrderResultModel : JSONModel

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *msgcode;
@property (nonatomic, strong) NSDictionary *data;

@end
